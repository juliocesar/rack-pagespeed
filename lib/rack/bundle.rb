require 'rack'
require 'nokogiri'

module Rack
  class Bundle
    attr_accessor :engine, :document
    autoload :FileSystemStore,  'rack/bundle/file_system_store'
    autoload :JSBundle,         'rack/bundle/js_bundle'
    autoload :CSSBundle,        'rack/bundle/css_bundle'
    
    def initialize app, options = {:engine => FileSystemStore.new}
      @app = app
      @engine = engine
      yield self if block_given?
    end
    
    def call env
      status, headers, response = @app.call(env)
      return @app.call(env) unless headers['Content-Type'] =~ /html/
      parse! response.body.join
      [status, headers, response]
    end
    
    def parse! html
      @document = Nokogiri::HTML(html)
    end
    
    def replace_javascripts!
      
    end
    
    def replace_stylesheets!
    end
    
    def optimize!
      replace_javascripts and replace_stylesheets!
    end
    
    def store
    end
  end
end