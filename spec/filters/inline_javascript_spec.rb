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

    it 'maximum size threshold is controlled via :max_size' do
      inliner = Rack::PageSpeed::Filters::InlineJavaScript.new FIXTURES.complex, 
        :max_size => 999999, # huge
        :public => FIXTURES_PATH
      inliner.execute!
      inliner.document.css('script:not([src])').count.should == 2
    end
  end
end
