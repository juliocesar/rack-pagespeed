require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::CSSBundle do
  before do
    @bundle = Rack::Bundle::CSSBundle.new $reset, $screen
  end
  
  it 'makes the contents of one or more stylesheets accessible via #contents' do
    @bundle.contents.should == [$reset, $screen].join("\n")
  end
  
  it 'creates a MD5 hash out of the contents of the bundle' do    
    @bundle.hash.should == MD5.new(@bundle.contents).to_s
  end
end