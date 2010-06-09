require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::FileSystemStore do  
  it "keeps a collection of bundles in #bundles" do
    subject.bundles.should be_an Array
  end
  
  it "defaults to the system's temporary dir" do
    subject.dir.should == Dir.tmpdir
  end
  
  it "stores bundles in a location specified on the argument when instancing" do
    Rack::Bundle::FileSystemStore.new(FIXTURES_PATH).dir.should == FIXTURES_PATH
  end
  
  context 'storing bundles in the file system' do
    before do
      @store = Rack::Bundle::FileSystemStore.new
      @jsbundle   = mock(Rack::Bundle::JSBundle, :contents => 'All we are saaaaaayin...', :hash => MD5.new($jquery))
      @cssbundle  = mock(Rack::Bundle::CSSBundle, :contents => '... is give peace a chaaaaance', :hash => MD5.new($screen))
      @store.bundles.concat [@jsbundle, @cssbundle]
      @store.save!
    end
    
    it 'skips saving a bundle if one with a matching hash already exists' do
      File.should_not_receive(:open)
      @store.save!
    end
    
    it 'stores Javascripts in a single Javascript file' do
      File.size(File.join(@store.dir, "rack-bundle-#{@jsbundle.hash}.js")).should > 0
    end
    
    it 'stores stylesheets in a single CSS file' do
      File.size(File.join(@store.dir, "rack-bundle-#{@cssbundle.hash}.css")).should > 0
    end
  end
end