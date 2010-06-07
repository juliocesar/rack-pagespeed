require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::JSBundle do
  before do
    @bundle = Rack::Bundle::JSBundle.new $jquery, $mylib
  end
  
  it 'contents of one or more Javascript file(s) accessible via #contents' do
    @bundle.contents.should == [$jquery, $mylib].join(';')
  end
  
  it 'creates a MD5 hash out of the contents of the bundle' do    
    @bundle.hash.should == MD5.new(@bundle.contents)
  end
end