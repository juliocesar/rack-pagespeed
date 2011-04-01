require 'tmpdir'

class Rack::PageSpeed::Store::Disk
  def initialize path = Dir.tmpdir
    raise ArgumentError, "#{path} is not a directory" unless File.directory? path
    @path = path
  end

  def [] key
    path = "#{@path}/bundle-#{key}"
    File.read path if File.exists? path
  end

  def []= key, value
    File.open("#{@path}/bundle-#{key}", 'w') { |file| file << value }
    true
  end
end