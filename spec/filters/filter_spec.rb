require File.dirname(__FILE__) + '/../spec_helper'

describe 'the base filter class' do
  before  { @base = Rack::PageSpeed::Filters::Base.new(FIXTURES.complex, :foo => 'bar') }
  subject { @base }
  
  it 'takes a Nokogiri HTML document as a paramater' do
    subject.document.should == FIXTURES.complex
  end
  
  it 'takes an options hash as a second argument' do
    subject.options[:foo].should == 'bar'
  end
  
  it 'errors out if no argument is passed to the initializer' do
    expect { Rack::PageSpeed::Filters::Base.new }.to raise_error    
  end
  
  context '#file_for returns a File object' do
    before { @base.options.stub(:[]).with(:public).and_return(FIXTURES_PATH) }
    
    it 'for a script' do
      script = FIXTURES.complex.at_css('#mylib')
      @base.send(:file_for, script).stat.size.should == File.size(File.join(FIXTURES_PATH, 'mylib.js'))
    end
    
    it "for a stylesheet" do
      style = FIXTURES.complex.at_css('link')
      @base.send(:file_for, style).stat.size.should == File.size(File.join(FIXTURES_PATH, 'reset.css'))
    end
  end
end
