module Marabunta
  module Hypervisor
    require 'erb'

    import org.libvirt.Connect
    import java.util.UUID

    class Kvm
      attr_reader :address

      TCP = "qemu+tcp://%s/system?no_tty"

      def self.connect(address)
        Kvm.new(address).connect
      end

      def initialize(ip_address, protocol = TCP)
        @address = protocol % ip_address
      end

      def connect
        @connection = Connect.new(@address, false)
        self
      end

      def disconnect
        @connection.close
      end

      def deploy(disks_path)
        disks_path.each do |disk|
          domain = KvmDomain[disk]

          @connection.domainDefineXML(domain).create
        end
      end
    end

    class KvmDomain
      def self.[](disk)
        KvmDomain.new(disk).create
      end

      def initialize(disk)
        @uuid = UUID.randomUUID.to_s
        @name = File.basename(disk)
        @volume_path = disk
        # TODO: allow more configuration options
      end

      def create
        template = ERB.new(File.read(File.expand_path('../kvm_domain.erb', __FILE__)))
        template.result(binding)
      end
    end
  end
end
