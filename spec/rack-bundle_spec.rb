require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::Bundle do
  before do
    @bundle = Rack::Bundle.new index_page, :public_dir => FIXTURES_PATH
    @env    = Rack::MockRequest.env_for('/')
  end

  it "needs to know where the application's public directory is" do
    lambda do Rack::Bundle.new(index_page) end.should raise_error(ArgumentError)
  end

  it 'defaults to FileSystemStore for storage' do
    Rack::Bundle.new(index_page, :public_dir => '.').storage.is_a? Rack::Bundle::FileSystemStore
  end

  context 'parsing the document' do
    before do 
      status, headers, @response = @bundle.call(@env) 
    end
    it "doesn't happen unless the response is HTML" do
      bundle = Rack::Bundle.new plain_text, :public_dir => FIXTURES_PATH
      bundle.should_not_receive :parse!
      bundle.call(@env)
    end

    it 'does so with Nokogiri' do
      @bundle.document.should be_a Nokogiri::HTML::Document
    end
  end

  context 'modifying the DOM' do
    before do
      @simple = Rack::Bundle.new simple_page, :public_dir => FIXTURES_PATH
    end
    
    it "skips #replace_javascripts! if there's only one script tag linking a Javascript in" do
      Rack::Bundle::JSBundle.should_not_receive :new
      @simple.call(@env)
    end
    
    it "replaces multiple references to external Javascrips to one single reference to the bundle" do
      @bundle.call(@env)
      jsbundle = @bundle.storage.bundles.select { |bundle| bundle.is_a? Rack::Bundle::JSBundle }.first
      @bundle.document.css("head script[src$=\"#{@bundle.send(:bundle_path, jsbundle)}\"]").count.should == 1
    end
    
    it "skips #replace_stylesheets! if there's only one stylesheet being included in" do
      Rack::Bundle::CSSBundle.should_not_receive :new
      @simple.call(@env)
    end
    
    it "replaces references to external stylesheets of the same media type to their respective bundle"
  end

  context 'private methods' do
    it 'returns a URL to a bundle on #bundle_path' do
      @jsbundle = Rack::Bundle::JSBundle.new 'omg'
      @bundle.send(:bundle_path, @jsbundle).should == "/rack-bundle-#{@jsbundle.hash}.js"
    end
  end
end