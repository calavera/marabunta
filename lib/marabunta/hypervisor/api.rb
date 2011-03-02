module Marabunta
  module Hypervisor
    require 'virtuoso'

    class API
      attr_reader :address, :connection

      def self.connect(address)
        new(address).connect
      end

      def connect
        @connection = Virtuoso.connect(address)
        self
      end

      def deploy(destination_path, disks)
        vm_class = Virtuoso.const_get(self.class.name.split('::').last).const_get(:VM)

        disks_path.each do |disk|
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
    end
  end
end
