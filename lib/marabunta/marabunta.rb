module Marabunta
  require 'java'

  __JARS__ = File.expand_path('../../../jars', __FILE__)
  require File.expand_path('jna-3.0.9.jar', __JARS__)
  require File.expand_path('libvirt-0.4.6.jar', __JARS__)
  require File.expand_path('../kvm', __FILE__)


  def self.deploy(machines, hypervisor, disks_path)
    unless Marabunta::Hypervisor.const_defined?(hypervisor)
      raise "Unsupported hypervisor: #{hypervisor}"
    end

    hypervisor = Marabunta::Hypervisor.const_get(hypervisor)

    machines.each do |machine|
      connection = hypervisor.connect(machine)

      connection.deploy(disks_path)

      connection.disconnect
    end
  end
end
