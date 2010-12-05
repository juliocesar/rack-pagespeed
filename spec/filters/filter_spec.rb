require File.dirname(__FILE__) + '/../spec_helper'

describe 'the base filter class' do
  it 'takes a Nokogiri HTML document as a paramater' do
    Rack::PageSpeed::Filters::Base.new(DOCUMENT).document.should == DOCUMENT
  end
  
  it 'takes an options hash as a second argument' do
    Rack::PageSpeed::Filters::Base.new(DOCUMENT, :foo => 'bar').options[:foo].should == 'bar'
  end
  
  it 'errors out if no argument is passed to the initializer' do
    expect { Rack::PageSpeed::Filters::Base.new }.to raise_error    
  end
end
