require 'rack'
require 'nokogiri'
require 'mime/types'

module Rack
  class PageSpeed
    attr_reader :config
    load "#{::File.dirname(__FILE__)}/pagespeed/filters/all.rb"
    autoload :Config, 'rack/pagespeed/config'

    def initialize app, options, &block
      @app = app
      @config = Config.new options, &block
    end

    def call env
      if match = %r(^/rack-pagespeed-(.*)).match(env['PATH_INFO'])
        respond_with match[1]
      else
        status, headers, @response = @app.call(env)
        return [status, headers, @response] unless headers['Content-Type'] =~ /html/
        body = ""; @response.each do |part| body << part end
        @document = Nokogiri::HTML(body)
        @config.filters.each do |filter|
          filter.execute! @document
        end
        body = @document.to_html
        headers['Content-Length'] = body.length.to_s if headers['Content-Length'] # still UTF-8 unsafe
        [status, headers, [body]]        
      end
    end
    
    def respond_with asset_id
      store = @config.options[:store]
      if asset = store[asset_id]
        [
          200,
          { 'Content-Type' => (MIME::Types.type_for(asset_id).first.content_type rescue 'application/octet-stream') },
          [asset]
        ]
      else
        [404, {'Content-Type' => 'text/plain'}, ['Not found']]
      end
    end
  end
end
