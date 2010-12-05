require 'rack'
require 'nokogiri'
require 'nokogiri/manipulator'

module Rack
  class PageSpeed
    attr_reader :filters, :config
    autoload :Config, 'rack/pagespeed/config'
    
    def initialize app, config
      @app = app
      @config = Config.new(config)
      yield @config if block_given?
    end
  end
end