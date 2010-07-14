require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::CSSBundle do
  before do
    @bundle = make_css_bundle
  end
  
  it "should return 'css' as #extension" do
    subject.extension.should == "css"
  end
  
  it "should return 'text/css' as #mime_type" do
    subject.mime_type.should == "text/css"
  end      
end