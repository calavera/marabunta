require File.expand_path('../../spec_helper',  __FILE__)

describe Marabunta::Ovf do
  it "creates a new object with the ovf file content" do
    create_ovf.should_not be_nil
  end

  it "returns the file path name of the disks from the reference section" do
    disks = create_ovf.disks
    disks.should include('lamp-base.vmdk')
    disks.should include('lamp-db.vmdk')
    disks.should include('lamp-app.vmdk')
  end

  def create_ovf
    Marabunta::Ovf.new(
      File.expand_path('../../fixtures/lamp-multi-vm.ovf', __FILE__)
    )
  end
end
