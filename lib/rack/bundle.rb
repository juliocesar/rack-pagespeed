require 'rack'
require 'nokogiri'

module Rack
  class Bundle
    SELECTORS = Struct.new('Selector', :js, :css).new(
      'head script[src$=".js"]:not([src^="http"])',
      'head link[href$=".css"]:not([href^="http"])'
    )
    attr_accessor :storage, :document, :public_dir
    autoload :FileSystemStore,  'rack/bundle/file_system_store'
    autoload :DatabaseStore,    'rack/bundle/database_store'
    autoload :JSBundle,         'rack/bundle/js_bundle'
    autoload :CSSBundle,        'rack/bundle/css_bundle'

    def initialize app, options = {}
      @app, @public_dir = app, options[:public_dir]
      @storage = options[:storage] || FileSystemStore.new(@public_dir)
      yield self if block_given?      
      raise ArgumentError, ":public_dir needs to be a directory" unless ::File.directory?(@public_dir.to_s)
    end

    def call env
      if match = %r(^/rack-bundle-(\w+)).match(env['PATH_INFO'])
        bundle = @storage.find_bundle_by_hash match[1]
        bundle ? respond_with(bundle) : not_found
      else
        status, headers, @response = @app.call(env)
        return [status, headers, @response] unless headers['Content-Type'] =~ /html/
        parse!
        replace_javascripts!
        replace_stylesheets!
        [status, headers, [@document.to_html]]
      end
    end

    def parse!
      @document = Nokogiri::HTML(@response.join)
    end

    def replace_javascripts!
      return unless @document.css(SELECTORS.js).count > 1
      bundle = JSBundle.new *scripts
      @storage.add bundle unless @storage.has_bundle? bundle
      bundle_node = @document.create_element 'script',
        :type     => 'text/javascript',
        :src      => bundle_path(bundle),
        :charset  => 'utf-8'
      @document.css(SELECTORS.js).first.before(bundle_node)
      @document.css(SELECTORS.js).slice(1..-1).remove
      @document
    end

    def replace_stylesheets!
      return unless local_css_nodes.count > 1
      styles = local_css_nodes.group_by { |node| node.attribute('media').value rescue nil }
      styles.each do |media, nodes|
        next unless nodes.count > 1
        stylesheets = stylesheet_contents_for nodes
        bundle = CSSBundle.new *stylesheets
        @storage.add bundle unless @storage.has_bundle? bundle
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
      @document.css(SELECTORS.js)
    end

    def local_css_nodes
      @document.css(SELECTORS.css)
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

    def not_found
      [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
    end

    def respond_with bundle
      content_type = bundle.is_a?(JSBundle) ? 'text/javascript' : 'text/css'
      [200, {'Content-Type' => content_type}, [bundle.contents]]
    end
  end
end