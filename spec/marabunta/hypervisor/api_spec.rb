require File.expand_path('../../../spec_helper', __FILE__)

describe "Marabunta::Hypervisor::API" do
  let(:address) { '10.60.1.2' }

  context "connecting to kvm" do

    let(:vm) do
      Virtuoso::Kvm::VM.any_instance.tap do |mock|
        mock.expects(:save)
        mock.expects(:start)
      end
    end

    it "uses the host address to conect to the hypervisor" do
      host = Marabunta::Hypervisor::Kvm::TEMPLATE % address

      Virtuoso.expects(:connect).with(host).once

      Marabunta::Hypervisor::Kvm.connect(address)
    end

    it "uses the template passed in the connection options" do
      template = "qemu+ssh://%s/system"
      host = template % address

      Virtuoso.expects(:connect).with(host).once
      Marabunta::Hypervisor::Kvm.connect(address, {:template => template})
    end

    it "instances the required VM class form Virtuoso" do
      kvm = Marabunta::Hypervisor::Kvm.new address
      kvm.to_virt.should == Virtuoso::Kvm::VM
    end

    it "sets the disk image when the disks provided is a list of paths" do
      fixed_disk = '/tmp/disk1.vmdk'
      vm.expects(:disk_image).with(fixed_disk)

      kvm = Marabunta::Hypervisor::Kvm.new address
      kvm.deploy('/tmp', ['disk1.vmdk'])
    end

    it "sets the vm domain when the disks provided is a list of Libvirt::Spec::Domain" do
      domain = Libvirt::Spec::Domain.new
      vm.expects(:set_domain).with(nil)
      vm.expects(:set_domain).with(domain)

      kvm = Marabunta::Hypervisor::Kvm.new address
      kvm.deploy('/tmp', [domain])
    end
  end

  context "connecting with virtualbox" do
    it "uses the `user` option to set the host address" do
      opts = {:user => 'root'}
      host = Marabunta::Hypervisor::Virtualbox::TEMPLATE % [opts[:user], address]

      vbox = Marabunta::Hypervisor::Virtualbox.new(address, opts)
      vbox.address.should == host
    end
  end
end
