begin
  require 'dalli' # wanted to use Dalli, but it just ain't working here right now
rescue LoadError
  raise LoadError, ":dalli store requires the dalli gem to be installed."
end

class Rack::PageSpeed::Store::Dalli
  def initialize address_port = nil
    @client = Dalli::Client.new address_port
  end
  
  def [] key
    @client.get key
  end
  
  def []= key, value
    @client.set key, value
    true
  end
end