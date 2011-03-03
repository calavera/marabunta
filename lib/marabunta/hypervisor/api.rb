module Marabunta
  module Hypervisor
    require 'virtuoso'

    class API
      attr_reader :address, :connection

      def self.connect(address, opts = {})
        new(address, opts).connect
      end

      def initialize(ip_address, opts = {})
      end

      def connect
        @connection = Virtuoso.connect(address)
        self
      end

      def deploy(destination_path, disks)
        vm_class = to_virt

        disks.each do |disk|
          vm = vm_class.new @connection

          if disk.is_a?(Libvirt::Spec::Domain)
            vm.set_domain disk
          else
            vm.disk_image File.join(destination_path, disk)
          end

          vm.save
          vm.start
        end
      end

      def to_virt
        Virtuoso.const_get(hypervisor_name).const_get(:VM)
      end

      private
      def hypervisor_name
        self.class.name.split('::').last.to_sym
      end
    end
  end
end
