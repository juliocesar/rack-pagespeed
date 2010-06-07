require 'rack'
require 'nokogiri'

module Rack
  class Bundle
    attr_accessor :engine
    autoload :FileSystemStore,  'rack/bundle/file_system_store'
    autoload :JSBundle,         'rack/bundle/js_bundle'
    autoload :CSSBundle,        'rack/bundle/css_bundle'
    
    def initialize engine = FileSystemStore.new
      @engine = engine
    end
    
    def parse html
    end
    
    def store
    end
  end
end