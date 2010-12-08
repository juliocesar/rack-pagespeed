module Rack::PageSpeed::Filters
  class Base
    attr_reader :document, :options
    def initialize document, options = {}
      @document, @options, @manipulator = document, options
    end
    
    private
    def file_for node
      case node.name
      when 'script'
        ::File.open ::File.join(options[:public], node['src'])
      when 'link'
        ::File.open ::File.join(options[:public], node['href'])
      end
    end
  end
end