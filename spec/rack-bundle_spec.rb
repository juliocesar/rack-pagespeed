require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::Bundle do
  before do
    @bundle = Rack::Bundle.new index_page, :public_dir => FIXTURES_PATH
    @env    = Rack::MockRequest.env_for '/'
  end

  it "needs to know where the application's public directory is" do
    lambda do Rack::Bundle.new(index_page) end.should raise_error(ArgumentError)
  end

  it 'defaults to FileSystemStore for storage' do
    Rack::Bundle.new(index_page, :public_dir => FIXTURES_PATH).storage.is_a? Rack::Bundle::FileSystemStore
  end

  context 'serving bundles' do
    before do
      @jsbundle, @cssbundle = make_js_bundle, make_css_bundle
      @bundle.storage.add @jsbundle
      @bundle.storage.add @cssbundle
      @js_request   = Rack::MockRequest.env_for @jsbundle.path
      @css_request  = Rack::MockRequest.env_for @cssbundle.path
    end

    it "fetches a bundle from storage and serves if the request URL matches" do
      @bundle.storage.should_receive(:find_bundle_by_hash).with(@jsbundle.hash).and_return(@jsbundle)
      status, headers, response = @bundle.call @js_request
      response.join.should == @jsbundle.contents
    end

    context 'the Content-Length header' do
      it "gets updated if it's been previously set" do
        app = Rack::Builder.new do
          use Rack::Lint
          use Rack::Bundle, :public_dir => FIXTURES_PATH
          use Rack::ContentLength
          run index_page
        end
        status, headers, response = app.call @env
        output = ""
        response.each do |part| output << part end
        headers['Content-Length'].should == output.length.to_s
      end

      it "isn't touched if it's not set" do
        app = Rack::Builder.new do
          use Rack::Lint
          use Rack::Bundle, :public_dir => FIXTURES_PATH
          run index_page
        end
        status, headers, response = app.call(@env)
        headers['Content-Length'].should == nil
      end
    end
  end

  context 'parsing the document' do
    before do
      status, headers, @response = @bundle.call(@env)
    end
    
    it "doesn't happen unless the response is HTML" do
      bundle = Rack::Bundle.new plain_text, :public_dir => FIXTURES_PATH
      bundle.should_not_receive :parse!
      bundle.call @env
    end

    it 'does so with Nokogiri' do
      @bundle.document.should be_a Nokogiri::HTML::Document
    end
  end

  context 'modifying the DOM' do
    before do
      @simple = Rack::Bundle.new simple_page, :public_dir => FIXTURES_PATH
    end

    it "leaves externally hosted Javascripts alone" do
      @bundle.call @env
      @bundle.document.css
    end

    it "skips #replace_javascripts! if there's only one script tag linking a Javascript in" do
      Rack::Bundle::JSBundle.should_not_receive :new
      @simple.call @env
    end

    it "replaces multiple references to Javascrips to one single reference to the bundle" do
      @bundle.call @env
      @bundle.document.css(Rack::Bundle::SELECTORS.js).count.should == 1
    end

    it "skips #replace_stylesheets! if there's only one stylesheet being included in" do
      Rack::Bundle::CSSBundle.should_not_receive :new
      @simple.call @env
    end

    it "replaces references to external stylesheets of the same media type to their respective bundle" do
      @bundle.call @env
      styles = @bundle.document.css(Rack::Bundle::SELECTORS.css).group_by { |node| node.attribute('media').value rescue nil }
      styles.each_key do |media|
        styles[media].count.should == 1
      end
    end
  end
end