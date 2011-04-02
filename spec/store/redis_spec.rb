require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "redis storage" do
  before :all do
    @store = Rack::PageSpeed::Store::Redis.new
    @client = @store.instance_variable_get(:@client)
  end

  context 'writing' do
    it "writes with a Hash-like syntax" do
      @client.should_receive(:set).with('omg', 'value')
      @store['omg'] = "value"
    end
  end

  context 'reading' do
    it "reads with a Hash-like syntax" do
      @client.set 'hola', 'Hola mundo'
      @store['hola'].should == "Hola mundo"
    end
  end
end