require 'jsmin'
begin
  require 'md5'
rescue LoadError
  require 'digest/md5'
end

class Rack::PageSpeed::Filters::MinifyJavaScript < Rack::PageSpeed::Filters::Base
  name 'minify_javascript'
  requires_store
      
  def execute! document
    nodes = document.css('script[src$=".js"]:not([src^="http"])')
    return false unless nodes.count > 0
    nodes.each do |node|
      if match = %r(^/rack-pagespeed-(.*)).match(node['src'])
        store = @options[:store]
        store[match[1]] = JSMin.minify store[match[1]]
      else
        file = file_for node
        javascript = file.read
        unique_id = Digest::MD5.hexdigest javascript
        inline = Nokogiri::XML::Node.new 'script', document
        inline.content = JSMin.minify file.read
        node.before inline
        node.remove
      end
    end
  end
end
