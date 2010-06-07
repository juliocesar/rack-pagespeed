require 'md5'

class Rack::Bundle::JSBundle
  def initialize files
    @files = files, @hash = MD5.new
  end  
end