begin
  require 'md5'
rescue LoadError
  require 'digest/md5'
end

class Rack::PageSpeed::Filters::CombineJavaScripts < Rack::PageSpeed::Filters::Base
  name 'combine_javascripts'
  
  def initialize options
    super
    raise ArgumentError, ":store needs to be specified" unless @options[:store]
    @store = options[:store]
  end

  def execute! document
    nodes = document.css('script[src$=".js"]:not([src^="http"]) + script[src$=".js"]:not([src^="http"])')
    return false unless nodes.count > 0
    groups = group_siblings nodes
    groups.each do |group|
      save_nodes group
      merged = merge group, document
      group.first.before merged
      group.map { |node| node.remove }
    end
  end

  private
  def save_nodes nodes
    contents = nodes.map { |node| file_for(node).read rescue "" }
    nodes_id = unique_id nodes
    @store["#{nodes_id}.js"] = contents
  end
  
  def merge nodes, document
    nodes_id = unique_id nodes
    node = Nokogiri::XML::Node.new 'script', document
    node['src'] = "/rack-pagespeed-#{nodes_id}.js"
    node
  end

  def unique_id nodes
    Digest::MD5.hexdigest nodes.map { |node| file = file_for node; file.mtime.to_i.to_s + file.read }.join
  end

  def group_siblings nodes
    nodes.inject([]) do |result, node|
      group, current = [], node
      group << node
      while previous = current.previous_sibling
        break if previous['src'].match(/^http/) # not consistent with the pattern above
        current = previous
        group.unshift current
      end
      result << group
    end
  end
end
