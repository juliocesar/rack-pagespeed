require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::Bundle::FileSystemStore do
  it "uses a file to store the bundle in the file system" do
  end
  
  it "defaults to the system's temporary dir" do
    subject.dir.should == Dir.tmpdir
  end
end