require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::FileSystemStore do  
  before do
    @jsbundle, @cssbundle = make_js_bundle, make_css_bundle
    @storage = Rack::Bundle::FileSystemStore.new FIXTURES_PATH
    @storage.add @jsbundle
    @storage.add @cssbundle    
  end
  
  it "stores bundles in a location specified on the argument when instancing" do
    Rack::Bundle::FileSystemStore.new(FIXTURES_PATH).dir.should == FIXTURES_PATH
  end
  
  it "defaults to the system's temporary dir" do
    subject.dir.should == Dir.tmpdir
  end
  
  it "finds a bundle by it's hash on #find_bundle_by_hash" do
    @storage.find_bundle_by_hash(@jsbundle.hash).should be_an_instance_of Rack::Bundle::JSBundle
  end
  
  it "clears existing bundles when initializing" do
    FileUtils.touch FIXTURES_PATH + '/rack-bundle-1234567890.js'
    Rack::Bundle::FileSystemStore.new FIXTURES_PATH
    File.exists?(FIXTURES_PATH + '/rack-bundle-1234567890.js').should be_false
  end
  
  it "checks if a bundle exists with #has_bundle?" do
    @storage.has_bundle?(@jsbundle).should be_true
  end
    
  context 'storing bundles in the file system' do
    it 'skips saving a bundle if one with a matching hash already exists' do
      File.should_not_receive(:open)
    end
    
    it 'stores Javascripts in a single Javascript file' do
      File.size(File.join(@storage.dir, "rack-bundle-#{@jsbundle.hash}.js")).should > 0
    end
    
    it 'stores stylesheets in a single CSS file' do
      File.size(File.join(@storage.dir, "rack-bundle-#{@cssbundle.hash}.css")).should > 0
    end
  end
end