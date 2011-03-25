require File.dirname(__FILE__) + '/../spec_helper'

describe 'the combine_css filter' do
  it "is called \"combine_css\" as far as Config is concerned" do
    Rack::PageSpeed::Filters::CombineCSS.name.should == 'combine_css'
  end

  it "requires a store mechanism to be passed via :store when initializing" do
    expect { Rack::PageSpeed::Filters::CombineCSS.new }.to raise_error
  end
  
  it "is a priority 9 filter" do
    Rack::PageSpeed::Filters::CombineCSS.priority.should == 9
  end

  context 'execute!' do
    before :each do
      @filter = Rack::PageSpeed::Filters::CombineCSS.new :public => Fixtures.path, :store => {}
    end

    it 'cuts down the number of scripts in the fixtures from 5 to 1' do
      expect { @filter.execute! Fixtures.complex }.to change { Fixtures.complex.css('link[rel="stylesheet"][href$=".css"]:not([href^="http"])').count }.from(5).to(1)
    end
    
    it "stores the nodes' contents in the store passed through the initializer" do
      @filter.instance_variable_get(:@options)[:store].should_receive(:[]=)
      @filter.execute! Fixtures.complex
    end
  end
end