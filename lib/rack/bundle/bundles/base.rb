begin
  require 'digest/md5'
  MD5 = Digest::MD5
rescue LoadError
  require 'md5'
end

class Rack::Bundle::Base  
  class << self; attr_accessor :extension, :joiner, :mime_type; end
  attr_accessor :contents, :files
  
  def self.new_from_contents contents
    instance = new
    instance.contents = contents
    instance
  end
  
  def initialize *files
    @files = files
  end
  
  def contents
    @contents ||= @files.map { |file| file.contents }.join(joiner)
  end
  
  def hash
    @hash ||= MD5.hexdigest(@files.map { |file| File.basename(file.path) + File.mtime(file.path).to_s }.join)
  end
  
  def path
    "/rack-bundle-#{hash}.#{extension}"
  end
  
  def extension
    self.class.extension
  end
  
  def joiner
    self.class.joiner
  end
  
  def mime_type
    self.class.mime_type
  end
  
  def == bundle
    self.class == bundle.class && hash == bundle.hash
  end  
end