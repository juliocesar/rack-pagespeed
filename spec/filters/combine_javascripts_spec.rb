require File.dirname(__FILE__) + '/../spec_helper'

describe 'the combine_javascripts filter' do
  context 'yes, I test private methods, so what?' do
    before do
      @filter = Rack::PageSpeed::Filters::CombineJavaScripts.new :public => FIXTURES_PATH
    end

    it 'returns an array of arrays containing JS nodes that are next to each other in #group_siblings' do
      nodes = FIXTURES.complex.css('script[src$=".js"]:not([src^="http"]) + script[src$=".js"]:not([src^="http"])')
      result = @filter.send :group_siblings, nodes
      result.should == [[nodes[0].previous_element, nodes[0]], [nodes[1].previous_element, nodes[1]]]
    end

    it '#unique_id a key thats unique to the nodes combination of content + mtime' do
      nodes = FIXTURES.complex.css('script[src$=".js"]:not([src^="http"]) + script[src$=".js"]:not([src^="http"])')
      @filter.send(:unique_id, nodes).should == Digest::MD5.hexdigest(nodes.map { |node| file = @filter.send(:file_for, node); file.mtime.to_i.to_s + file.read }.join)
    end
  end
end