require 'md5'

class Rack::Bundle::JSBundle
  attr_accessor :contents, :hash
  def initialize *files
    @contents = files.join ';'
    @hash = MD5.new @contents
  end  
end