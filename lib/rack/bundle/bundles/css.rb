require File.dirname(__FILE__) + '/base'

class Rack::Bundle::CSSBundle < Rack::Bundle::Base  
  @extension, @joiner, @mime_type = "css", "\n", "text/css"
end