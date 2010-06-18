require 'tmpdir'

class Rack::Bundle::FileSystemStore
  attr_accessor :dir, :bundles
  
  def initialize dir = Dir.tmpdir
    @dir = dir
  end
  
  def find_bundle_by_hash hash
    found = Dir["#{dir}/rack-bundle-#{hash}.*"]
    return nil unless found.any?
    type, contents = File.extname(found.first).sub(/^./, ''), File.read(File.join(dir, File.basename(found.first)))
    type == 'js' ? Rack::Bundle::JSBundle.new(contents) : Rack::Bundle::CSSBundle.new(contents)
  end
    
  def has_bundle? bundle
    File.exists? "#{dir}/rack-bundle-#{bundle.hash}.#{bundle.extension}"
  end
  
  def add bundle
    File.open("#{dir}/rack-bundle-#{bundle.hash}.#{bundle.extension}", 'w') do |file|
      file << bundle.contents
    end    
  end    
end