begin
  require 'dalli'
rescue LoadError
  raise LoadError, ":memcached store requires the dalli gem to be installed."
end

class Rack::PageSpeed::Store::Memcached
  def initialize *args
    @client = Dalli::Client.new *args
    # @client.stats # let it raise errors if it can't connect
  end
  
  def [] key
    @client.get key
  end
  
  def []= key, value
    @client.set key, value
    true
  end
end