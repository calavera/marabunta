module Marabunta
  module Hypervisor
    class Kvm < API
      TEMPLATE = "qemu+tcp://%s/system?no_tty"

      def initialize(ip_address, opts = {})
        template = opts[:template] || TEMPLATE
        @address = template % ip_address
      end
    end
  end
end
