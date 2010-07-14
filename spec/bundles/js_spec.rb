require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::JSBundle do
  before do
    @bundle = make_js_bundle
  end

  it "should return 'js' as #extension" do
    subject.extension.should == "js"
  end

  it "should return 'text/javascript' as #mime_type" do
    subject.mime_type.should == "text/javascript"
  end
  
  it 'compresses Javascript when you try to access the #contents' do
    pending
    @bundle.contents.length.should < [$jquery.contents, $mylib.contents].join(";").length
  end
end