require File.dirname(__FILE__) + '/../spec_helper'

describe 'the inline_css filter' do
  it "is called \"inline_images\" as far as Config is concerned" do
    Rack::PageSpeed::Filters::InlineImages.name.should == 'inline_images'
  end
  
  it "is a priority 8 filter" do
    Rack::PageSpeed::Filters::InlineImages.priority.should == 8
  end
  
  context "#execute!" do
    before :each do
      @filter = Rack::PageSpeed::Filters::InlineImages.new :public => Fixtures.path, :max_size => 2048
      @document = Fixtures.complex
      @filter.execute! @document
    end

    it "returns false if there are no images in the document" do
      Rack::PageSpeed::Filters::InlineImages.new(:public => Fixtures.path).execute!(Fixtures.noexternalcss).should be_false
    end

    it 'inlines images files that are smaller than 1kb in size by default using data URI' do
      image = fixture 'all-small-dog-breeds.jpg'
      @document.at_css('img:last')['src'].should == "data:image/jpeg;base64,#{[image].pack('m')}"
    end
  end
end