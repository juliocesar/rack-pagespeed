require File.dirname(__FILE__) + '/spec_helper'

describe 'rack-pagespeed configuration' do
  before do
    class Rack::PageSpeed::Filters::StripsNaked < Rack::PageSpeed::Filters::Base; end
    class Rack::PageSpeed::Filters::MakesItLookGood < Rack::PageSpeed::Filters::Base 
      attr_accessor :options
      def initialize document, options = {}; @options = options; end
    end
    
  end
  
  context 'when instancing a new object' do
    it 'creates methods from constants found in Rack::PageSpeed::Filters' do
      Rack::PageSpeed::Config.new("trance" => "dance").should respond_to :strips_naked
    end
  end
  
  context 'enabling filters, options hash based' do
    context 'options[:filters]' do
      it "if it's an array, it enables filters listed in it with their default options" do
        config = Rack::PageSpeed::Config.new :filters => [:makes_it_look_good]
        config.filters.first.should be_a Rack::PageSpeed::Filters::MakesItLookGood
      end
      
      it "if it's a hash, it let's you pass options to the filters logically" do
        config = Rack::PageSpeed::Config.new :filters => {:makes_it_look_good => {:test => 6000}}
        filter = config.filters.first
        filter.should be_a Rack::PageSpeed::Filters::MakesItLookGood
        filter.options[:test].should == 6000 # yeah, 2 assertions, bad, bad
      end
    end
    
    it 'raises a NoSuchFilterError when a non-existing filter is passed to :filters' do
      expect { Rack::PageSpeed.new page, :filters => [:whoops!] }.to raise_error
    end
  end
  
  context 'enabling filters, block/DSL based' do
    it "let's you invoke filter names in a DSL-like way through the initializer" do
      config = Rack::PageSpeed::Config.new do
        makes_it_look_good :seriously => true
        strips_naked
      end
      config.filters.first.should be_a Rack::PageSpeed::Filters::MakesItLookGood
      config.filters.last.should be_a Rack::PageSpeed::Filters::StripsNaked
    end
  end
end
