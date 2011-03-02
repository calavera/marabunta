module Marabunta
  class Configuration
    attr_accessor :hypervisor,
                  :repository,
                  :destination,
                  :peers,
                  :seeder,
                  :tracker,
                  :murder_path,
                  :disks,
                  :connection_options

    def initialize
      @peers, @connection_opts = []
      @destination = '/var/lib/virt'
      @murder_path = '/var/lib/murder'
    end

    def final_path
      File.join(destination, ENV['tag'] || '')
    end

    def scan_repository?
      disks.nil? || disks.empty?
    end
  end
end
