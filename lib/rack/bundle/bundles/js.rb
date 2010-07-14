require File.dirname(__FILE__) + '/base'

class Rack::Bundle::JSBundle < Rack::Bundle::Base  
  @extension, @joiner, @mime_type = "js", ";", "text/javascript"
end