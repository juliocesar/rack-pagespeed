require File.dirname(__FILE__) + '/../spec_helper'

describe 'the inline_javascript filter' do
  context "executing" do
    before :each do
      @inliner = Rack::PageSpeed::Filters::InlineJavaScript.new FIXTURES.complex, :public => FIXTURES_PATH
      @inliner.execute!
    end

    it "returns false if there are no script nodes in the document" do
      Rack::PageSpeed::Filters::InlineJavaScript.new(FIXTURES.noscripts).execute!.should be_false
    end

    it 'inlines JavaScripts that are smaller than 2kb in size by default' do
      @inliner.document.at_css('script:not([src])').content.should == fixture('mylib.js')
    end

    it 'takes a size threshold parameter via :minimum_size' do
      inliner = Rack::PageSpeed::Filters::InlineJavaScript.new FIXTURES.complex, 
        :minimum_size => 999999,
        :public => FIXTURES_PATH
      inliner.execute!
      inliner.document.css('script:not([src])').count.should == 2
    end
  end
end
