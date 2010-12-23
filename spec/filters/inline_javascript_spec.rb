require File.dirname(__FILE__) + '/../spec_helper'

describe 'the inline_javascript filter' do
  it "is called \"inline_javascripts\" as far as Config is concerned" do
    Rack::PageSpeed::Filters::InlineJavaScripts.name.should == 'inline_javascripts'
  end
  it "is a priority 10 filter" do
    Rack::PageSpeed::Filters::InlineJavaScripts.priority.should == 10
  end
  
  context "#execute!" do
    before :each do
      @inliner = Rack::PageSpeed::Filters::InlineJavaScripts.new :public => Fixtures.path
    end

    it "returns false if there are no script nodes in the document" do
      Rack::PageSpeed::Filters::InlineJavaScripts.new(:public => Fixtures.path).execute!(Fixtures.noscripts).should be_false
    end

    it 'inlines JavaScripts that are smaller than 2kb in size by default' do
      @inliner.execute! Fixtures.complex
      Fixtures.complex.at_css('script:not([src])').content.should == fixture('mylib.js')
    end

    it 'does stuff, and the maximum size threshold is controlled via :max_size' do
      inliner = Rack::PageSpeed::Filters::InlineJavaScripts.new :max_size => 999999, :public => Fixtures.path
      expect { inliner.execute! Fixtures.complex }.to change { Fixtures.complex.css('script:not([src])').count }.by(4)
    end
  end
end