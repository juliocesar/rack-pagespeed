class Rack::PageSpeed::Filters::InlineJavaScripts < Rack::PageSpeed::Filter
  name      'inline_javascripts'
  priority  10
      
  def execute! document
    nodes = document.css('script[src]')
    return false unless nodes.count > 0
    nodes.each do |node|
      file = file_for node
      next if !file or file.stat.size > (@options[:max_size] or 2048)
      inline = Nokogiri::XML::Node.new 'script', document
      inline.content = file.read
      node.before inline
      node.remove
    end
  end
end
