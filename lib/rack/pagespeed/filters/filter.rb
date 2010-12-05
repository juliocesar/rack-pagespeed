class Rack::PageSpeed::Filter
  attr_reader :document, :options
  def initialize document, options = {}
    @document, @options = document, options
  end  
end