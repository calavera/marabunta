require File.expand_path('../../spec_helper',  __FILE__)

describe Marabunta do
  it "does nothing if the hypervisor is not supported" do
    lambda {
      Marabunta.deploy([], 'Xen', '/tmp')
    }.should raise_error
  end

  it "loads the hypervisor if it's supported" do
    lambda {
      Marabunta.deploy([], 'Kvm', '/tmp')
    }.should_not raise_error
  end

  it "connects with each machine's hypervisor" do
    kvm = mock
    kvm.expects(:deploy)
    kvm.expects(:disconnect)

    Marabunta::Hypervisor::Kvm.expects(:connect).
      with('localhost').
      returns(kvm)

    Marabunta.deploy(['localhost'], 'Kvm', '/tmp')
  end
end
