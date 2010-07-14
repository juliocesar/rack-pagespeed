require 'rack'
require 'nokogiri'

class File
  def contents
    _contents = read
    rewind
    _contents
  end
end

module Rack
  class Bundle
    SELECTORS = Struct.new('Selector', :js, :css).new(
      'head script[src$=".js"]:not([src^="http"])',
      'head link[href$=".css"]:not([href^="http"])'
    )
    attr_accessor :storage, :document, :public_dir
    autoload :FileSystemStore,  'rack/bundle/file_system_store'
    autoload :DatabaseStore,    'rack/bundle/database_store'
    autoload :JSBundle,         'rack/bundle/bundles/js'
    autoload :CSSBundle,        'rack/bundle/bundles/css'

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
        body = @document.to_html
        headers['Content-Length'] = body.length.to_s if headers['Content-Length'] # Not sure how UTF-8 plays into this
        [status, headers, [body]]
      end
    end

    def parse!
      body = ""
      @response.each do |part| body << part end
      @document = Nokogiri::HTML(body)
    end

    def replace_javascripts!
      return unless @document.css(SELECTORS.js).count > 1
      bundle = JSBundle.new *scripts
      @storage.add bundle unless @storage.has_bundle? bundle
      bundle_node = @document.create_element 'script',
        :type     => 'text/javascript',
        :src      => bundle.path,
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
        stylesheets = stylesheets_for nodes
        bundle = CSSBundle.new *stylesheets
        @storage.add bundle unless @storage.has_bundle? bundle
        node = @document.create_element 'link',
          :rel    => 'stylesheet',
          :type   => 'text/css',
          :href   => bundle.path,
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
      local_javascript_nodes.inject([]) do |files, node|
        path = ::File.join(@public_dir, node.attribute('src').value)
        files << ::File.open(path) if ::File.exists?(path)
        files
      end
    end

    def stylesheets_for nodes
      nodes.inject([]) do |files, node|
        path = ::File.join(@public_dir, node.attribute('href').value)
        files << ::File.open(path) if ::File.exists?(path)
        files
      end
    end

    def not_found
      [404, {'Content-Type' => 'text/plain'}, ['Not Found']]
    end

    def respond_with bundle
      [200, {'Content-Type' => bundle.mime_type}, [bundle.contents]]
    end
  end
end