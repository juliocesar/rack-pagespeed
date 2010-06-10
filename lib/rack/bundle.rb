require 'rack'
require 'nokogiri'

module Rack
  class Bundle
    attr_accessor :storage, :document, :js_path, :css_path
    autoload :FileSystemStore,  'rack/bundle/file_system_store'
    autoload :JSBundle,         'rack/bundle/js_bundle'
    autoload :CSSBundle,        'rack/bundle/css_bundle'
    
    def initialize app, options = {}
      @app = app
      @js_path, @css_path, @public = options[:js_path], options[:css_path], options[:public]
      raise ArgumentError, ":public needs to be a directory" unless ::File.directory? @public.to_s
      @storage = FileSystemStore.new @public
      yield self if block_given?
    end
    
    def call env
      status, headers, @response = @app.call(env)
      return [status, headers, @response] unless headers['Content-Type'] =~ /html/
      parse!
      replace_javascripts!
      [status, headers, [@document.to_html]]
    end
    
    def parse!
      @document = Nokogiri::HTML(@response.body.join)
    end
    
    def replace_javascripts!
      return false unless @js_path
      bundle = JSBundle.new *scripts
      unless @storage.has_bundle? bundle
        @storage.bundles << bundle
        @storage.save!      
      end
      node = @document.create_element 'script', 
        :type     => 'text/javascript', 
        :src      => bundle_path(bundle),
        :charset  => 'utf-8'
      @document.css('head script:first').before(node)
      @document.css('head script:gt(1)').remove
      @document
    end
    
    def replace_stylesheets!
      return false unless @css_path
      styles = @document.css('link[rel="stylesheet"]').group_by { |node| node.attribute('media').value }
    end
    
    def optimize!
      # replace_javascripts and replace_stylesheets!
    end
    
    def store
    end
    
    private    
    def scripts
      nodes = @document.css('script[src$=".js"]')
      nodes.inject([]) do |contents, node|
        path = ::File.join(@js_path, node.attribute('src').value)
        contents << ::File.read(path) if ::File.exists?(path)
        contents
      end
    end
    
    def bundle_path bundle
      '/rack-bundle-' + bundle.hash + '.' + (bundle.is_a?(JSBundle) ? 'js' : 'css')
    end
        
  end
end