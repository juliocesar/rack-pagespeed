begin
  require 'redis'
rescue LoadError
  raise LoadError, ":redis store requires the redis gem to be installed."
end

class Rack::PageSpeed::Store::Redis
  def initialize *args
    @client = Redis.new *args
  end
  
  def [] key
    @client.get key
  end
  
  def []= key, value
    @client.set key, value
  end
end