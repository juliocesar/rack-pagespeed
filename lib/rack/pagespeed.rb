require 'rack'
require 'nokogiri'

module Rack
  class PageSpeed
    module Filters; load "#{::File.dirname(__FILE__)}/pagespeed/filters/all.rb"; end
    
    attr_reader :filters, :config
    autoload :Config, 'rack/pagespeed/config'
    
    def initialize app, config, &block
      @app = app
      @config = Config.new(config)
      @config.instance_eval &block if block_given?
    end    
  end
end
