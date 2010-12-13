require File.dirname(__FILE__) + '/../spec_helper'

describe 'memcached storage' do
  before :all do
    MemcachedStore = Rack::PageSpeed::MemcachedStore
    @store = MemcachedStore.new
    @client = @store.instance_variable_get(:@client)
  end
  
  context 'initializing' do
    it "errors out if it can't connect to Memcached" do
      expect { MemcachedStore.new('ohfoo').new }.to raise_error
    end
  end
  
  context 'writing' do
    it "writes to disk with a Hash-like syntax" do
      @client.should_receive(:set).with('omg', 'value')
      @store['omg'] = "value"
    end
  end
  
  context 'reading' do
    it "reads from disk with a Hash-like syntax" do
      @client.set 'hola', 'Hola mundo'
      @store['hola'].should == "Hola mundo"
    end
  end
end