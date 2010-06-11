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
      @document = Nokogiri::HTML(@response.join)
    end
    
    def replace_javascripts!
      return false unless local_javascript_nodes.count > 1
      bundle = JSBundle.new *scripts
      @storage.bundles << bundle and @storage.save! unless @storage.has_bundle? bundle
      bundle_node = @document.create_element 'script', 
        :type     => 'text/javascript', 
        :src      => bundle_path(bundle),
        :charset  => 'utf-8'
      local_javascript_nodes.first.before(bundle_node)
      local_javascript_nodes.slice(0..-1).remove
      @document
    end
    
    def replace_stylesheets!
      return false unless local_css_nodes.count > 1
      styles = local_css_nodes.group_by { |node| node.attribute('media').value rescue nil }
      styles.each do |media, nodes|
        next unless nodes.count > 1
        stylesheets = stylesheet_contents_for nodes
        bundle = CSSBundle.new *stylesheets
        @storage.bundles << bundle and @storage.save! unless @storage.has_bundle? bundle        
        node = @document.create_element 'link', 
          :rel    => 'stylesheet', 
          :type   => 'text/css',
          :href   => bundle_path(bundle),
          :media  => media
        nodes.first.before(node)
        nodes.map { |node| node.remove }
      end
      @document
    end
        
    private
    def local_javascript_nodes
      @js_nodes ||= @document.css('head script[src$=".js"]:not([src^="http"])')
    end
    
    def local_css_nodes
      @css_nodes ||= @document.css('head link[href$=".css"]:not([href^="http"])')
    end
    
    def scripts
      local_javascript_nodes.inject([]) do |contents, node|
        path = ::File.join(@public_dir, node.attribute('src').value)
        contents << ::File.read(path) if ::File.exists?(path)
        contents
      end
    end
    
    def stylesheet_contents_for nodes
      nodes.inject([]) do |contents, node|
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