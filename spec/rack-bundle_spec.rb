require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::Bundle do
  
  before do
    @bundle = Rack::Bundle.new(index_page, :js_path => FIXTURES_PATH, :css_path => FIXTURES_PATH)
    @env = Rack::MockRequest.env_for('/')
  end
  
  it 'defaults to FileSystemStore for storage' do
    @bundle.engine.is_a? Rack::Bundle::FileSystemStore
  end
  
  it 'needs to know where Javascripts are stored' do
    pending
  end
  
  it 'needs to know where stylesheets are stored' do
    pending
  end
    
  context 'parsing HTML' do
    before do 
      status, headers, @response = @bundle.call(@env) 
    end
    
    it "doesn't happen unless the response is HTML" do
      bundle = Rack::Bundle.new plain_text
      bundle.should_not_receive :parse!
      bundle.call(@env)
    end
          
    it 'does so with Nokogiri' do
      @bundle.document.should be_a Nokogiri::HTML::Document
    end
    
    it "extracts all external links to Javascript files and instances a JSBundle with them" do
    end
    it "extracts all links to CSS and instances a CSSBundle with them"
    it "stores the bundle(s) using the currently available engine"
  end
end