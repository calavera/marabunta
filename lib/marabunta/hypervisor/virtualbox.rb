module Marabunta
  module Hypervisor
    class Virtualbox < API
      TEMPLATE = 'vbox+tcp://%s@%s/session'

      def initialize(ip_address, opts = {})
        template = opts[:template] || TEMPLATE

        args = []
        args << opts[:user] if opts[:user]
        args << ip_address

        @address = template % args
      end
    end
  end
end
