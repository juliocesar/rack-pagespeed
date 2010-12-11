require File.dirname(__FILE__) + '/../spec_helper'

describe 'the inline_css filter' do
  context "#execute!" do
    before :each do
      @filter = Rack::PageSpeed::Filters::InlineCSS.new :public => FIXTURES_PATH
      @document = FIXTURES.styles
      @filter.execute! @document
    end

    it "returns false if there are no external CSS nodes in the document" do
      Rack::PageSpeed::Filters::InlineCSS.new(:public => FIXTURES_PATH).execute!(FIXTURES.noexternalcss).should be_false
    end

    it 'inlines CSS files that are smaller than 2kb in size by default' do
      @document.at_css('style').content.should == fixture('screen.css')
    end

    it 'does stuff, and the maximum size threshold is controlled via :max_size' do
      filter = Rack::PageSpeed::Filters::InlineCSS.new :max_size => 999999, :public => FIXTURES_PATH
      filter.execute! @document
      @document.css('style').count.should == 2
    end
  end
end