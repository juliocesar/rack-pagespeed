require File.dirname(__FILE__) + '/../spec_helper'

describe 'the minify_javascript filter' do
  it "is called \"minify_javascript\" as far as Config is concerned" do
    Rack::PageSpeed::Filters::MinifyJavaScript.name.should == 'minify_javascript'
  end

  context "requires a storage mechanism to be passed via :store when initializing" do
    specify { Rack::PageSpeed::Filters::MinifyJavaScript.new.should be_false }
    specify { Rack::PageSpeed::Filters::MinifyJavaScript.new(:store => {}).should_not be_false }
  end

  context "#execute!" do
    before :each do
      @filter = Rack::PageSpeed::Filters::MinifyJavaScript.new :public => Fixtures.path, :store => {}
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
      end

      it "finding a rack-pagespeed-* reference, it compresses what's in storage" do
        @filter.execute! Fixtures.complex
        @store["#{@hash}.js"].should == JSMin.minify(@bundled)
      end
    end
    it 'compresses inline JavaScripts'
  end
end