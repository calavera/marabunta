module Marabunta
  VERSION = '0.1.0'
end

require 'marabunta/configuration'
require 'marabunta/cli'
require 'marabunta/deployer'
require 'marabunta/hypervisor/api'
require 'marabunta/hypervisor/kvm'
require 'marabunta/hypervisor/virtualbox'
