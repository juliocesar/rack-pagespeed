require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::FileSystemStore do  
  it "keeps a collection of bundles in #bundles" do
    subject.bundles.should be_an Array
  end
  
  it "defaults to the system's temporary dir" do
    subject.dir.should == Dir.tmpdir
  end
  
  it "uses a flat file to store a bundle in the file system" do
    bundle = Rack::Bundle::JSBundle.new @jquery
    subject.bundles << bundle
    subject.save!
    File.exists?(File.join(subject.dir, "rack-bundle-#{bundle.hash}.js")).should be_true
  end  
end