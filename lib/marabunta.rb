module Marabunta
  VERSION = '0.1.0'
end

require File.expand_path('../marabunta/marabunta', __FILE__)

Capistrano::Configuration.instance(:must_exist).load do

  # currently just 'Kvm' is supported
  set :hypervisor, ''

  namespace :marabunta do
    desc 'Deploy disks into the target machines'
    task :deploy, :role => :seeder do
      require_tag

      # TODO: find a better way to know the disks to deploy
      source_path = File.join(default_seeder_files_path, tag)
      disks = capture("ls #{source_path}").chomp

      destination_path = File.join(default_destination_path, tag)
      disks = disks.split("\s+").map {|file| File.join(destination_path, file) }

      Marabunta.deploy(roles[:peers].to_ary, hypervisor,  disks)
    end
  end
end
