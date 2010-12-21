require File.dirname(__FILE__) + '/../spec_helper'

describe 'the inline_css filter' do
  it "is called \"inline_css\" as far as Config is concerned" do
    Rack::PageSpeed::Filters::InlineCSS.name.should == 'inline_css'
  end
  
  it "is a priority 10 filter" do
    Rack::PageSpeed::Filters::InlineCSS.priority.should == 10
  end
  
  context "#execute!" do
    before :each do
      @filter = Rack::PageSpeed::Filters::InlineCSS.new :public => Fixtures.path
      @document = Fixtures.styles
      @filter.execute! @document
    end

    it "returns false if there are no external CSS nodes in the document" do
      Rack::PageSpeed::Filters::InlineCSS.new(:public => Fixtures.path).execute!(Fixtures.noexternalcss).should be_false
    end

    it 'inlines CSS files that are smaller than 2kb in size by default' do
      @document.at_css('style').content.should == fixture('screen.css')
    end

    it 'does stuff, and the maximum size threshold is controlled via :max_size' do
      filter = Rack::PageSpeed::Filters::InlineCSS.new :max_size => 999999, :public => Fixtures.path
      filter.execute! @document
      @document.css('style').count.should == 2
    end
  end
end