require 'rack'
require 'nokogiri'

module Rack
  class Bundle
    attr_accessor :storage, :document, :js_path, :css_path
    autoload :FileSystemStore,  'rack/bundle/file_system_store'
    autoload :JSBundle,         'rack/bundle/js_bundle'
    autoload :CSSBundle,        'rack/bundle/css_bundle'
    
    def initialize app, options = {:storage => FileSystemStore.new}
      @app, @storage      = app, options[:storage]
      @js_path, @css_path = options[:js_path], options[:css_path]
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
      scripts = @document.css('script[src!=""]')
    end
    
    def replace_stylesheets!
      styles = @document.css('link[rel="stylesheet"]').group_by { |node| node.attribute('media').value }
    end
    
    def optimize!
      replace_javascripts and replace_stylesheets!
    end
    
    def store
    end
  end
end