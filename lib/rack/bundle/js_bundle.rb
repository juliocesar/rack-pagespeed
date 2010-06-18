require 'md5'

class Rack::Bundle::JSBundle
  attr_accessor :contents, :hash
  def initialize *files
    @contents = files.join ';'
    @hash = MD5.new(@contents).to_s
  end
  
  def extension
    'js'
  end
  
  def == bundle
    self.class == bundle.class && hash == bundle.hash
  end  
end