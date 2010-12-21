begin
  require 'md5'
rescue LoadError
  require 'digest/md5'
end

class Rack::PageSpeed::Filters::CombineCSS < Rack::PageSpeed::Filters::Base
  requires_store
  priority 9
  
  def execute! document
    nodes = document.css('link[rel="stylesheet"][href$=".css"]:not([href^="http"])')
    return false unless nodes.count > 0
    groups = group_siblings topmost_of_sequence(nodes)
    groups.each do |group|
      save group
      merged = merge group, document
      group.first.before merged
      group.map { |node| node.remove }
    end
  end

  private
  def merge_contents nodes, separator = ';'
    nodes.map { |node| file_for(node).read rescue "" }.join("\n")
  end
  
  def save nodes
    contents = merge_contents nodes
    nodes_id = unique_id nodes
    @options[:store]["#{nodes_id}.css"] = contents
  end
  
  def local_css? node
    node.name == 'link' && !(node['href'] =~ /^http/ or !(node['href'] =~ /.css$/))
  end
  
  def topmost_of_sequence nodes
    result = []
    nodes.each do |node|
      _previous, _next = node.previous_sibling, node.next_sibling
      if _previous && local_css?(_previous) &&
        (!_next || !local_css?(_next))
        result << node
      end
    end
    result
  end
  
  def merge nodes, document
    nodes_id = unique_id nodes
    node = Nokogiri::XML::Node.new 'link', document
    node['rel'] = 'stylesheet'
    node['href'] = "/rack-pagespeed-#{nodes_id}.css"
    node
  end

  def unique_id nodes
    Digest::MD5.hexdigest nodes.map { |node| file = file_for node; file.mtime.to_i.to_s + file.read }.join
  end

  def group_siblings nodes
    nodes.inject([]) do |result, node|
      group, current = [], node
      group << node
      while previous = current.previous_sibling and local_css?(previous)
        current = previous
        group.unshift current
      end
      result << group
    end
  end
end
