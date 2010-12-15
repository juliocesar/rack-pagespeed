require 'memcached' # wanted to use Dalli, but it just ain't working here right now

class Rack::PageSpeed::Store::Memcached
  def initialize address_port = nil
    @client = Memcached.new address_port
    @client.stats # let it raise errors if it can't connect
  end
  
  def [] key
    @client.get key
  end
  
  def []= key, value
    @client.set key, value
    true
  end
end