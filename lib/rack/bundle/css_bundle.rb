require 'md5'

class Rack::Bundle::CSSBundle
  attr_accessor :contents, :hash
  def initialize *files
    @contents = files.join "\n"
    @hash = MD5.new(@contents).to_s
  end  
  
  def extension
    'css'
  end
  
  def == bundle
    self.class == bundle.class && hash == bundle.hash
  end  
end