require 'tmpdir'

class Rack::Bundle::FileSystemStore
  attr_accessor :dir, :bundles
  
  def initialize dir = Dir.tmpdir
    @dir = dir
    @bundles = []
  end
  
  def save!
    @bundles.each do |bundle|
      extension = bundle.is_a?(Rack::Bundle::JSBundle) ? 'js' : 'css'
      File.open("#{dir}/rack-bundle-#{bundle.hash}.#{extension}", 'w') do |file|
        file << bundle.contents
      end
    end
  end  
end