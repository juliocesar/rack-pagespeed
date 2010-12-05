module Rack::PageSpeed::Filters
  class Base
    attr_reader :document, :options
    def initialize document, options = {}
      @document, @options = document, options
    end  
  end
end