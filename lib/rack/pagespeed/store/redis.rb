begin
  require 'redis'
rescue LoadError
  raise LoadError, ":redis store requires the redis gem to be installed."
end

class Rack::PageSpeed::Store::Redis
  def initialize address_port = nil
    @client = if address_port.nil?
      Redis.new
    else
      address, port = address_port.split(":")
      Redis.new({ :address => address, :port => port })
    end
  end
  
  def [] key
    @client.get key
  end
  
  def []= key, value
    @client.set key, value
  end
end