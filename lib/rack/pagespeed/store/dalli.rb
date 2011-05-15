begin
  require 'dalli' # wanted to use Dalli, but it just ain't working here right now
rescue LoadError
  raise LoadError, ":dalli store requires the dalli gem to be installed."
end

class Rack::PageSpeed::Store::Dalli
  def initialize opts
    @client = Dalli::Client.new(opts[:servers], :username => opts[:username], :password => opts[:password])
  end
  
  def [] key
    @client.get key
  end
  
  def []= key, value
    @client.set key, value
    true
  end
end