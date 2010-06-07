require 'rack'
require 'nokogiri'

module Rack
  class Bundle
    attr_accessor :engine
    autoload :FileSystemStore, 'rack/bundle/file_system_store'
    
    def initialize engine = FileSystemStore.new
      @engine = engine
    end
    
    def parse html
    end
    
    def store
    end
  end
end