require 'tmpdir'

class Rack::Bundle::FileSystemStore
  attr_accessor :dir
  
  def initialize dir = Dir.tmpdir
    @dir = dir
  end
end