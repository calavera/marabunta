require File.expand_path('../../spec_helper',  __FILE__)

describe Marabunta::Configuration do
  it 'uses /var/lib/virt as default destination path' do
    subject.destination.should == '/var/lib/virt'
  end

  it "uses /var/lib/murder as default murder's path" do
    subject.murder_path.should == '/var/lib/murder'
  end

  it "uses `marabunta` as default user name to connect to the nodes with Capistrano" do
    subject.cap_user.should == 'marabunta'
  end

  it 'generates the final destination path with destination + tag' do
    ENV['tag'] = 'foobar'
    subject.destination = '/tmp'

    subject.final_path.should == '/tmp/foobar'
  end

  it 'scans the repository when disks are empty' do
    subject.scan_repository?.should be_true
  end

  it "doesn't scan the repository when disks are not empty" do
    subject.disks = ['disk1.vmdk', 'disk2.vmdk']

    subject.scan_repository?.should be_false
  end
end
