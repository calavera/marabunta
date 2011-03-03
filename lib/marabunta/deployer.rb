module Marabunta
  require 'capistrano'

  class Deployer
    attr_reader :cap, :configuration

    def initialize(configuration)
      ENV['tag'] = Time.now.utc.to_s.gsub /\W/, ''

      @configuration = configuration
      @cap = capify configuration
    end

    def setup!
      distribute_instances
    end

    def deploy!
      distribute_disks
      define_domains
    end

    def define_domains
      if configuration.scan_repository?
        configuration.disks = configure_default_disks(configuration)
      end

      hypervisor = define_hypervisor

      configuration.peers.each do |peer|
        connection = hypervisor.connect(peer, configuration.connection_options)

        connection.deploy configuration.final_path, configuration.disks
      end
    end

    def configure_default_disks(configuration)
      disks = cap.capture("ls #{configuration.repository}").chomp

      disks.split("\s+")
    end

    def define_hypervisor
      hypervisor = configuration.hypervisor
      unless Marabunta::Hypervisor.const_defined?(hypervisor)
        raise "Unsupported hypervisor: #{hypervisor}"
      end

      Marabunta::Hypervisor.const_get(hypervisor)
    end

    def distribute_disks
      require 'murder'

      cap.find_and_execute_task 'murder:start_seeding'
      cap.find_and_execute_task 'murder:start_tracker'

      cap.find_and_execute_task 'murder:deploy'

      cap.find_and_execute_task 'murder:stop_tracker'
      cap.find_and_execute_task 'murder:stop_seeding'
    end

    def distribute_instances
      require 'murder'

      cap.find_and_execute_task 'murder:distribute_files'
    end

    private
    def capify(configuration)
      cap = Capistrano::Configuration.new.tap do |cap|
        cap.set :scm, :none
        cap.set :user, configuration.cap_user
        cap.set :repository, configuration.repository
        cap.set :default_seeder_files_path, configuration.repository
        cap.set :remote_murder_path, configuration.murder_path
        cap.set :default_destination_path, configuration.destination
        cap.role(:seeder) { configuration.seeder }
        cap.role(:tracker) { configuration.tracker }
        cap.role(:peer) { configuration.peers }
      end

      Thread.current[:capistrano_configuration] = cap

      cap
    end
  end
end
