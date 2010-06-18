require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::DatabaseStore do  
  before do
    ENV['DATABASE_URL'] = "sqlite://#{Dir.tmpdir}/foo.db"
    @db_store = Rack::Bundle::DatabaseStore.new
  end
  
  context 'initializing' do
    it 'looks for a DATABASE_URL environment variable when a database URL is not specified' do
      @db_store.db.url.should == "sqlite:/#{Dir.tmpdir}/foo.db"
    end
    it 'takes a database url as a parameter' do
      db_store = Rack::Bundle::DatabaseStore.new "sqlite://#{Dir.tmpdir}/bar.db"
      db_store.db.url.should == "sqlite:/#{Dir.tmpdir}/bar.db"
    end
    it 'creates a table to store bundles in' do
      @db_store.db.tables.should include(:rack_bundle)
    end
  end
  
  context '#find_bundle_by_hash' do
    it 'takes a bundle hash as argument and returns a matching bundle' do
      jsbundle = Rack::Bundle::JSBundle.new fixture('jquery-1.4.1.min.js'), fixture('mylib.js')
      @db_store.db[:rack_bundle].insert(:hash => jsbundle.hash, :contents => jsbundle.contents, :type => 'js')
      @db_store.find_bundle_by_hash(jsbundle.hash).should == jsbundle
    end    
    it "returns nil when a bundle can't be found with a matching hash" do
      @db_store.find_bundle_by_hash('non existant').should be_nil
    end
  end
  
  it "saves bundles to the database on #save!" do
    jsbundle = mock_js_bundle
    @db_store.bundles << jsbundle
    @db_store.save!
    @db_store.db[:rack_bundle].where(:hash => jsbundle.hash).first[:hash].should == jsbundle.hash
  end
end