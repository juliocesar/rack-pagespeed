class Rack::PageSpeed::Filters::InlineImages < Rack::PageSpeed::Filter
  priority 8
  
  def execute! document
    nodes = document.css('img')
    return false unless nodes.count > 0
    nodes.each do |node|
      file = file_for node
      next if !file or file.stat.size > (@options[:max_size] or 1024)
      img = Nokogiri::XML::Node.new 'img', document
      img['src'] = "data:#{Rack::Mime.mime_type(File.extname(file.path))};base64,#{[file.read].pack('m')}"
      img['alt'] = node['alt'] if node['alt']
      node.before img
      node.remove
    end
  end
end
