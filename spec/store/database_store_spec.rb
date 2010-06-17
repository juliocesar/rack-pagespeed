require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::DatabaseStore do  
  context 'initializing' do
    before do
      ENV['DATABASE_URL'] = 'sqlite:///tmp/foo.db'
      @db_store = Rack::Bundle::DatabaseStore.new
    end
    
    it 'looks for a DATABASE_URL environment variable when a database URL is not specified' do
      @db_store.db.url.should == 'sqlite://tmp/foo.db'
    end
    it 'takes a database url as a parameter' do
      db_store = Rack::Bundle::DatabaseStore.new 'sqlite:///tmp/bar.db'
      db_store.db.url.should == 'sqlite://tmp/bar.db'
    end
    it 'creates a table to store bundles in' do
      @db_store.db.tables.should include(:rack_bundle)
    end
  end
end