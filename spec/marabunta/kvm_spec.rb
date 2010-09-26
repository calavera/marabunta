require File.expand_path('../../spec_helper',  __FILE__)

describe Marabunta::Hypervisor::Kvm do
  it "creates a new instance for each connection" do
    org.libvirt.Connect.expects(:new).twice.returns(mock)

    conn1 = Marabunta::Hypervisor::Kvm.connect('localhost')
    conn2 = Marabunta::Hypervisor::Kvm.connect('localhost')

    conn1.should_not == conn2
  end

  it "uses tcp connection by default" do
    org.libvirt.Connect.expects(:new).returns(mock)
    conn = Marabunta::Hypervisor::Kvm.connect('localhost')

    conn.address.should == (Marabunta::Hypervisor::Kvm::TCP % 'localhost')
  end

  it "creates a new domain for each disk" do
    connection_mock = mock
    domain_mock = mock

    domain_mock.expects(:create).twice
    connection_mock.expects(:domainDefineXML).twice.
      returns(domain_mock)

    org.libvirt.Connect.expects(:new).returns(connection_mock)

    conn = Marabunta::Hypervisor::Kvm.connect('localhost')
    conn.deploy(['disk1', 'disk2'])
  end

  context 'domain' do
    it "generates an uuid for each disk" do
      domain1 = Marabunta::Hypervisor::KvmDomain.new('disk1').create
      domain2 = Marabunta::Hypervisor::KvmDomain.new('disk2').create

      xml_value(domain1, 'uuid').should_not == xml_value(domain2, 'uuid')
    end

    it "uses the basename of the disk as domain name" do
      domain = Marabunta::Hypervisor::KvmDomain.new('/tmp/disk').create

      xml_value(domain, 'name').should == 'disk'
    end

    it "uses the full disk path as volume path" do
      domain = Marabunta::Hypervisor::KvmDomain.new('/tmp/disk').create

      domain[%r{<source file="([^"]+)"}, 1].should == '/tmp/disk'
    end

    def xml_value(xml, node)
      xml[%r{<(#{node})>(.+)</\1>}, 2]
    end
  end
end
