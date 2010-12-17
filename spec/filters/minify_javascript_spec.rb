require File.dirname(__FILE__) + '/../spec_helper'

describe 'the minify_javascript filter' do
  it "is called \"minify_javascript\" as far as Config is concerned" do
    Rack::PageSpeed::Filters::MinifyJavaScript.name.should == 'minify_javascript'
  end

  context "requires a store mechanism to be passed via :store when initializing" do
    specify { Rack::PageSpeed::Filters::MinifyJavaScript.new.should be_false }
    specify { Rack::PageSpeed::Filters::MinifyJavaScript.new(:store => {}).should_not be_false }
  end

  context "#execute!" do
    before :each do
      @filter = Rack::PageSpeed::Filters::MinifyJavaScript.new :public => Fixtures.path
    end

    it "returns false if there are no script nodes in the document" do
      Rack::PageSpeed::Filters::MinifyJavaScript.new(:public => Fixtures.path, :store => {}).execute!(Fixtures.noscripts).should be_false
    end

    it 'compresses outlined JavaScripts' 
    it 'compresses inline JavaScripts'
  end
end