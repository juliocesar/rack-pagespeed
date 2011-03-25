require File.dirname(__FILE__) + '/../spec_helper'

describe 'the combine_javascripts filter' do
  it "is called \"combine_javascripts\" as far as Config is concerned" do
    Rack::PageSpeed::Filters::CombineJavaScripts.name.should == 'combine_javascripts'
  end

  it "is a priority 9 filter" do
    Rack::PageSpeed::Filters::CombineJavaScripts.priority 9
  end

  context "requires a store mechanism to be passed via :store when initializing" do
    specify { expect { Rack::PageSpeed::Filters::CombineJavaScripts.new }.to raise_error }
    specify { expect { Rack::PageSpeed::Filters::CombineJavaScripts.new(:store => {}) }.to_not raise_error }
  end

  context 'execute!' do
    before :each do
      @filter = Rack::PageSpeed::Filters::CombineJavaScripts.new :public => Fixtures.path, :store => {}
    end

    it 'cuts down the number of scripts in the fixtures from 4 to 2' do
      expect { @filter.execute! Fixtures.complex }.to change { Fixtures.complex.css('script[src$=".js"]:not([src^="http"])').count }.from(4).to(2)
    end

    it "stores the nodes' contents in the store passed through the initializer" do
      @filter.instance_variable_get(:@options)[:store].should_receive(:[]=).twice
      @filter.execute! Fixtures.complex
    end
  end

  context 'yes, I test private methods, so what?' do
    before do
      @filter = Rack::PageSpeed::Filters::CombineJavaScripts.new :public => Fixtures.path, :store => {}
    end

    it 'returns an array of arrays containing JS nodes that are next to each other in #group_siblings' do
      nodes = Fixtures.complex.css('script[src$=".js"]:not([src^="http"]) + script[src$=".js"]:not([src^="http"])')
      result = @filter.send :group_siblings, nodes
      result.should == [[nodes[0].previous_element, nodes[0]], [nodes[1].previous_element, nodes[1]]]
    end
    
    context 'the #unique_id method' do
      it "generates a hash thats unique to the nodes' combination of content + mtime in the absence of @options[:hash]" do
        nodes = Fixtures.complex.css('script[src$=".js"]:not([src^="http"]) + script[src$=".js"]:not([src^="http"])')
        @filter.send(:unique_id, nodes).should == Digest::MD5.hexdigest(nodes.map { |node| file = @filter.send(:file_for, node); file.mtime.to_i.to_s + file.read }.join)
      end
      
      it "uses values for hashes estipulated in @options[:hash] if any" do
        nodes = []
        nodes << Fixtures.complex.at_css('script[src="ohno.js"]')
        nodes << Fixtures.complex.at_css('script[src="foo.js"]')
        filter = Rack::PageSpeed::Filters::CombineJavaScripts.new :store => {}, :hash => { %W(ohno.js foo.js) => "romanking" }
        filter.send(:unique_id, nodes).should == "romanking"
      end
    end
  end
end