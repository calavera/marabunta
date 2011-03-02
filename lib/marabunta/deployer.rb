module Marabunta
  require 'capistrano'

  class Deployer
    attr_reader :cap, :configuration

    def initialize(configuration)
      ENV['tag'] = Time.now.utc.to_s.gsub /\W/, ''

      @configuration = configuration
      @cap = capify configuration
    end

    def deploy!
      distribute_disks
      define_domains
    end

    def define_domains
      if configuration.scan_repository?
        configuration.disks = configure_default_disks(configuration)
      end

      hypervisor = configuration.hypervisor
      unless Marabunta::Hypervisor.const_defined?(hypervisor)
        raise "Unsupported hypervisor: #{hypervisor}"
      end

      hypervisor = Marabunta::Hypervisor.const_get(hypervisor)

      configuration.peers.each do |peer|
        connection = hypervisor.connect(peer, configuration.connection_options)

        connection.deploy configuration.destination_path configuration.disks
      end
    end

    def configure_default_disks(configuration)
      disks = cap.capture("ls #{configuration.repository}").chomp

      disks.split("\s+")
    end

    private
    def capify(configuration)
      cap = Capistrano::Configuration.new({
        :scm => :none,
        :user => 'marabunta',
        :repository => configuration.repository,
        :default_seeder_files_path => configuration.repository,
        :remote_murder_path => configuration.murder_path,
        :default_destination_path => config.destination
      })

      cap.role(:seeder, configuration.seeder)
      cap.role(:tracker, configuration.tracker)
      cap.role(:peers, configuration.peers)

      Thread.current[:capistrano_configuration] = cap

      cap
    end

    def distribute_disks
      require 'murder'

      cap.find_and_execute_task 'murder:start_seeding'
      cap.find_and_execute_task 'murder:start_tracker'

      cap.find_and_execute_task 'murder:deploy'

      cap.find_and_execute_task 'murder:stop_seeding'
      cap.find_and_execute_task 'murder:stop_tracker'
    end
  end
end
