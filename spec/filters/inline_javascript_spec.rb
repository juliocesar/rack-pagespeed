require File.dirname(__FILE__) + '/../spec_helper'

describe 'the inline_javascript filter' do
  context "#execute!" do
    before :each do
      @inliner = Rack::PageSpeed::Filters::InlineJavaScript.new :public => FIXTURES_PATH
      @document = FIXTURES.complex
      @inliner.execute! @document
    end

    it "returns false if there are no script nodes in the document" do
      Rack::PageSpeed::Filters::InlineJavaScript.new(:public => FIXTURES_PATH).execute!(FIXTURES.noscripts).should be_false
    end

    it 'inlines JavaScripts that are smaller than 2kb in size by default' do
      @document.at_css('script:not([src])').content.should == fixture('mylib.js')
    end

    it 'does stuff, and the maximum size threshold is controlled via :max_size' do
      inliner = Rack::PageSpeed::Filters::InlineJavaScript.new :max_size => 999999, :public => FIXTURES_PATH
      inliner.execute! @document
      @document.css('script:not([src])').count.should == 2
    end
  end
end