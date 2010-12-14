require File.dirname(__FILE__) + '/../spec_helper'

describe 'the inline_javascript filter' do
  it "is called \"inline_javascript\" as far as Config is concerned" do
    Rack::PageSpeed::Filters::InlineJavaScript.name.should == 'inline_javascript'
  end
  
  context "#execute!" do
    before :each do
      @inliner = Rack::PageSpeed::Filters::InlineJavaScript.new :public => FIXTURES_PATH
    end

    it "returns false if there are no script nodes in the document" do
      Rack::PageSpeed::Filters::InlineJavaScript.new(:public => FIXTURES_PATH).execute!(FIXTURES.noscripts).should be_false
    end

    it 'inlines JavaScripts that are smaller than 2kb in size by default' do
      @inliner.execute! FIXTURES.complex
      FIXTURES.complex.at_css('script:not([src])').content.should == fixture('mylib.js')
    end

    it 'does stuff, and the maximum size threshold is controlled via :max_size' do
      inliner = Rack::PageSpeed::Filters::InlineJavaScript.new :max_size => 999999, :public => FIXTURES_PATH
      expect { inliner.execute! FIXTURES.complex }.to change { FIXTURES.complex.css('script:not([src])').count }.by(4)
    end
  end
end