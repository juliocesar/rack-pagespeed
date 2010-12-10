require File.dirname(__FILE__) + '/spec_helper'

describe 'rack-pagespeed configuration' do
  context 'when instancing a new object' do
    before do
      class Rack::PageSpeed::Filters::Dummy < Rack::PageSpeed::Filters::Base; end
    end
    
    it 'creates methods from constants found in Rack::PageSpeed::Filters' do
      Rack::PageSpeed::Config.new("trance" => "dance").should respond_to :dummy
    end
  end
  
  context 'passing options, hash based' do
    context 'options[:filters]' do
      it "if it's an array, it enables filters listed in it with their default options" do
        pagespeed = Rack::PageSpeed.new page, :filters => [:inline_javascript]
        pagespeed.config.filters.first.should be_a Rack::PageSpeed::Filters::InlineJavaScript
      end
      
      it "if it's a hash, it let's you pass options to the filters logically" do
        pagespeed = Rack::PageSpeed.new page, :filters => {:inline_javascript => {:max_size => 6000}}
        filter = pagespeed.config.filters.first
        filter.should be_a Rack::PageSpeed::Filters::InlineJavaScript
        filter.options[:max_size].should == 6000 # yeah, 2 assertions, bad, bad
      end
    end
    
    it 'raises a NoSuchFilterError when a non-existing filter is passed to :filters' do
      pending
      expect { Rack::PageSpeed.new page, :filters => [:whoops!] }.to raise_error
    end
  end
  
  context 'block/DSL based' do
    pending
  end
end
