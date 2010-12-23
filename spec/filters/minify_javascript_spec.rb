require File.dirname(__FILE__) + '/../spec_helper'

describe 'the minify_javascript filter' do
  it "is called \"minify_javascript\" as far as Config is concerned" do
    Rack::PageSpeed::Filters::MinifyJavaScripts.name.should == 'minify_javascripts'
  end
  
  it "is a priority 8 filter" do
    Rack::PageSpeed::Filters::MinifyJavaScripts.priority.should == 8
  end

  context "requires a storage mechanism to be passed via :store when initializing" do
    specify { Rack::PageSpeed::Filters::MinifyJavaScripts.new.should be_false }
    specify { Rack::PageSpeed::Filters::MinifyJavaScripts.new(:store => {}).should_not be_false }
  end

  context "#execute!" do
    before :each do
      @filter = Rack::PageSpeed::Filters::MinifyJavaScripts.new :public => Fixtures.path, :store => {}
    end

    it "returns false if there are no script nodes in the document" do
      @filter.execute!(Fixtures.noscripts).should be_false
    end

    context 'compressing outlined JavaScripts' do
      before do
        @store = @filter.options[:store]
        @bundled = [fixture('ohno.js'), fixture('foo.js')].join ';'
        @hash = Digest::MD5.hexdigest File.mtime(Fixtures.path + '/ohno.js').to_i.to_s +
          fixture('ohno.js') +
          File.mtime(Fixtures.path + '/foo.js').to_i.to_s +
          fixture('foo.js')
        @store["#{@hash}.js"] = @bundled
        node = Nokogiri::XML::Node.new 'script', Fixtures.complex
        node['src'] = "/rack-pagespeed-#{@hash}.js"
        Fixtures.complex.at_css('script[src*="ohno.js"]').before node
        Fixtures.complex.at_css('script[src*="ohno.js"]').remove
        Fixtures.complex.at_css('script[src*="foo.js"]').remove
        @filter.execute! Fixtures.complex
      end

      it "finding a rack-pagespeed-* reference, it compresses what's in storage" do
        @store["#{@hash}.js"].should == JSMin.minify(@bundled)
      end

      it "finding a local script, compresses and puts it in storage" do
        hash = Digest::MD5.hexdigest File.mtime(Fixtures.path + '/jquery-1.4.1.min.js').to_i.to_s +
          fixture('jquery-1.4.1.min.js')
        @filter.options[:store]["#{hash}.js"].should == JSMin.minify(fixture('jquery-1.4.1.min.js'))
      end
    end
    it 'compresses inline JavaScripts' do
      script = Fixtures.complex.at_css('#alabaster').clone
      @filter.execute! Fixtures.complex
      Fixtures.complex.at_css('#alabaster').content.should == JSMin.minify(script.content)
    end
  end
end