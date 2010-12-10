require 'rack'
require 'nokogiri'

module Rack
  class PageSpeed
    module Filters; load "#{::File.dirname(__FILE__)}/pagespeed/filters/all.rb"; end
    
    attr_reader :config
    autoload :Config, 'rack/pagespeed/config'
    
    def initialize app, options, &block
      @app = app
      @config = Config.new options, &block
    end    
  end
end
