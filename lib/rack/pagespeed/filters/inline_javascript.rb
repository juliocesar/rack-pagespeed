module Rack::PageSpeed::Filters
  class InlineJavaScript < Base
    method 'inline_javascript'
        
    def execute! document
      nodes = document.css('script[src$=".js"]:not([src^="http"])')
      return false unless nodes.count > 0
      nodes.each do |node|
        file = file_for node
        next if file.stat.size > (@options[:max_size] or 2048)
        inline = Nokogiri::XML::Node.new 'script', document
        inline.content = file.read
        node.before inline
        node.remove
      end
    end
  end
end