class Rack::PageSpeed::Config
  class NoSuchFilterError < RuntimeError; end
  
  attr_reader :filters
  
  def initialize options = {}
    @filters = options[:filters]
  end
  
  def enable filter
    @filters << filter
  end
  
  def inline_javascript
    
  end
end