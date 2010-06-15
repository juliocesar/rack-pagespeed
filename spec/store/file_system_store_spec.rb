require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::FileSystemStore do  
  before do
    @jsbundle, @cssbundle = mock_js_bundle, mock_css_bundle
    @storage = Rack::Bundle::FileSystemStore.new FIXTURES_PATH
    @storage.bundles << @jsbundle
    @storage.bundles << @cssbundle    
  end
  
  it "stores bundles in a location specified on the argument when instancing" do
    Rack::Bundle::FileSystemStore.new(FIXTURES_PATH).dir.should == FIXTURES_PATH
  end
  
  it "keeps a collection of bundles in #bundles" do
    subject.bundles.should be_an Array
  end
  
  it "defaults to the system's temporary dir" do
    subject.dir.should == Dir.tmpdir
  end
  
  it "finds a bundle by it's hash on #find_bundle_by_hash" do
    @storage.find_bundle_by_hash(@jsbundle.hash).should == @jsbundle
  end
    
  context 'storing bundles in the file system' do
    before do      
      @storage.bundles.concat [@jsbundle, @cssbundle]
      @storage.save!
    end
    
    it "checks if a bundle exists with #has_bundle?" do
      @storage.has_bundle?(@jsbundle).should be_true
    end

    it 'skips saving a bundle if one with a matching hash already exists' do
      File.should_not_receive(:open)
      @storage.save!
    end
    
    it 'stores Javascripts in a single Javascript file' do
      File.size(File.join(@storage.dir, "rack-bundle-#{@jsbundle.hash}.js")).should > 0
    end
    
    it 'stores stylesheets in a single CSS file' do
      File.size(File.join(@storage.dir, "rack-bundle-#{@cssbundle.hash}.css")).should > 0
    end
  end
end