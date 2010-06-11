require 'rack'
require 'nokogiri'

module Rack
  class Bundle
    attr_accessor :storage, :document, :public_dir
    autoload :FileSystemStore,  'rack/bundle/file_system_store'
    autoload :JSBundle,         'rack/bundle/js_bundle'
    autoload :CSSBundle,        'rack/bundle/css_bundle'
    
    def initialize app, options = {}
      @app, @public_dir = app, options[:public_dir]
      raise ArgumentError, ":public needs to be a directory" unless ::File.directory?(@public_dir.to_s)
      @storage = FileSystemStore.new @public_dir
      yield self if block_given?
    end
    
    def call env
      status, headers, @response = @app.call(env)
      return [status, headers, @response] unless headers['Content-Type'] =~ /html/
      parse!
      replace_javascripts!
      replace_stylesheets!
      [status, headers, [@document.to_html]]
    end
    
    def parse!
      @document = Nokogiri::HTML(@response.body.join)
    end
    
    def replace_javascripts!
      return false unless @document.css('head script[src$=".js"]').count > 1
      bundle = JSBundle.new *scripts
      @storage.bundles << bundle and @storage.save! unless @storage.has_bundle? bundle
      node = @document.create_element 'script', 
        :type     => 'text/javascript', 
        :src      => bundle_path(bundle),
        :charset  => 'utf-8'
      @document.css('head script:first').before(node)
      @document.css('head script:gt(1)').remove
      @document
    end
    
    def replace_stylesheets!
      return false unless @document.css('link[rel="styleshet"]').count > 1
      styles = @document.css('link[rel="stylesheet"]').group_by { |node| node.attribute('media').value }
      styles.each_key do |media|
        next unless styles[media].count > 1
        stylesheets = stylesheet_contents_for styles[media]
        bundle = CSSBundle.new *stylesheets
        @storage.bundles << bundle and @storage.save! unless @storage.has_bundle? bundle        
      end
    end
        
    private    
    def scripts
      @document.css('script[src$=".js"]').inject([]) do |contents, node|
        path = ::File.join(@public_dir, node.attribute('src').value)
        contents << ::File.read(path) if ::File.exists?(path)
        contents
      end
    end
    
    def stylesheet_contents_for nodes
      @document.css('link[href$=".css"]').inject([]) do |contents, node|
        path = ::File.join(@public_dir, node.attribute('href').value)
        contents << ::File.read(path) if ::File.exists?(path)
        contents
      end      
    end
    
    def bundle_path bundle
      "/rack-bundle-#{bundle.hash}.#{bundle.extension}"
    end
  end
end