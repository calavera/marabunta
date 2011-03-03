require File.expand_path('../../spec_helper', __FILE__)

describe "Marabunta::Deployer" do
  let(:configuration) do
    Marabunta::Configuration.new.tap do |config|
      config.hypervisor = :Kvm
      config.repository = '/tmp'
      config.peers = ['10.60.1.2', '10.60.1.1']
    end
  end

  let(:deployer) do
    Marabunta::Deployer.new(configuration)
  end

  let(:disks) do
    'disk1.vmdk disk2.vmdk'
  end

  it "creates a new tag for each deploy" do
    Marabunta::Deployer.new(configuration)
    ENV['tag'].should_not be_nil
  end

  it "creates a capistrano configuration instance" do
    Marabunta::Deployer.new(configuration)
    Thread.current[:capistrano_configuration].should_not be_nil
  end

  it "disables capistrano's scm" do
    deployer.cap[:scm].should == :none
  end

  it "uses marabunta as capistrano's configuration name" do
    deployer.cap[:user].should == 'marabunta'
  end

  it "calls murder tasks" do
    mock = Capistrano::Configuration.any_instance
    mock.expects(:find_and_execute_task).with('murder:start_seeding').once
    mock.expects(:find_and_execute_task).with('murder:start_tracker').once
    mock.expects(:find_and_execute_task).with('murder:deploy').once
    mock.expects(:find_and_execute_task).with('murder:stop_tracker').once
    mock.expects(:find_and_execute_task).with('murder:stop_seeding').once

    deployer.distribute_disks
  end

  it "scans the repository when configuration disks are not present" do
    mock = Capistrano::Configuration.any_instance
    mock.expects(:capture).once.returns(disks)

    expected = deployer.configure_default_disks(configuration)
    expected.should == disks.split("\s+")
  end

  it "raises an error when the hypervisor is not properly defined" do
    lambda {
      configuration.hypervisor = :XEN

      deployer.define_hypervisor
    }.should raise_error
  end

  it "returns the hypervisor's class when it's defined" do
    deployer.define_hypervisor.should == Marabunta::Hypervisor::Kvm
  end

  it "tries to deploy the disks in each peer" do
    mock = mock()
    mock.expects(:deploy).twice

    Marabunta::Hypervisor::Kvm.expects(:connect).twice.returns(mock)

    configuration.disks = disks.split("\s+")
    deployer.define_domains
  end

  it "distributes murder's configuration files when invokes setup!" do
    mock = Capistrano::Configuration.any_instance
    mock.expects(:find_and_execute_task).with('murder:distribute_files').once

    deployer.setup!
  end
end
