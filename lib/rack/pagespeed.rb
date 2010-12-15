require 'rack'
require 'nokogiri'

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
end
