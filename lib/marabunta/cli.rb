module Marabunta
  require 'thor'
  require 'libvirt'

  class CLI < Thor
    map "-v" => :version, "--version" => :version, "-h" => :help, "--help" => :help

    desc "version", "show version"
    def version
      shell.say Marabunta::VERSION
    end

    desc "help [command]", "show help for Marabunta or a specific command"
    def help(*args)
      super(*args)
    end

    def self.help(shell, *)
      list = printable_tasks
      shell.say <<-USAGE
Marabunta is a tool to deploy cloud nodes using Bittorrent and Libvirt.

Usage: marabunta command configuration_file

USAGE

      shell.say "Commands:"
      shell.print_table(list, :ident => 2, :truncate => true)
      shell.say
      class_options_help(shell)
    end

    desc "deploy [CONFIGURATION]", "deploy images using the Marabunta's configuration file"
    def deploy(configuration = "#{Dir.pwd}/Leiningen")
      config = load_config configuration

      raise 'hypervisor required' unless config.hypervisor
      raise "repository required" unless config.repository
      raise "seeder required" unless config.seeder
      raise "tracker required" unless config.tracker

      config.peers << config.seeder unless config.peers.include?(config.seeder)

      puts "are you seriously using bittorrent to copy files into the same machine?" if config.peers.size == 1

      Marabunta::Deployer.new(config).deploy!
    end

    private
    def load_config(configuration)
      instance_eval(File.read(configuration), configuration)
    end

    def marabunta(&block)
      Marabunta::Configuration.new.tap(&block)
    end
  end
end
