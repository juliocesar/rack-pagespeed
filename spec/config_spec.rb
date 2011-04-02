require File.dirname(__FILE__) + '/spec_helper'

describe 'rack-pagespeed configuration' do
  before do
    class StripsNaked < Rack::PageSpeed::Filter; end
    class MakesItLookGood < Rack::PageSpeed::Filter; end
  end

  context 'when instancing a new object' do
    it 'creates methods for each filter class found in Rack::PageSpeed::Filters::Base.available_filters' do
      Rack::PageSpeed::Config.new(:public => Dir.tmpdir).should respond_to :strips_naked
    end

    it "requires a :public parameter pointing to the app's public directory" do
      expect { Rack::PageSpeed::Config.new("foo" => "bar") }.to raise_error(ArgumentError)
    end
  end

  context 'sorts filter execution based on their specified order' do
    before do
      class Larry < Rack::PageSpeed::Filter; priority 3; end
      class Moe < Rack::PageSpeed::Filter; priority 2; end
      class Curly < Rack::PageSpeed::Filter; priority 1; end
      @config = Rack::PageSpeed::Config.new :public => Fixtures.path do
        curly
        larry
        moe
      end
    end
    
    it "Larry is first" do
      @config.filters.first.should be_a Larry
    end
        
    it "Moe is second" do
      @config.filters[1].should be_a Moe
    end
    
    it "Curly is last" do
      @config.filters.last.should be_a Curly
    end
  end

  context 'enabling filters, options hash based' do
    before { File.stub(:directory?).and_return(true) }

    it "if it's an array, it enables filters listed in it with their default options" do
      config = Rack::PageSpeed::Config.new :filters => [:makes_it_look_good]
      config.filters.first.should be_a MakesItLookGood
    end

    it "if it's a hash, it let's you pass options to the filters" do
      config = Rack::PageSpeed::Config.new :filters => {:makes_it_look_good => {:test => 6000}}
      filter = config.filters.first
      filter.should be_a MakesItLookGood
      filter.options[:test].should == 6000 # yeah, 2 assertions, bad, bad
    end

    it 'raises a NoSuchFilter error when a non-existing filter is passed to :filters' do
      expect { Rack::PageSpeed::Config.new :filters => [:whoops!] }.to raise_error(Rack::PageSpeed::Config::NoSuchFilter)
    end
  end

  context 'enabling filters, block/DSL based' do
    before { File.stub(:directory?).and_return(true) }

    it "let's you invoke filter names in a DSL-like fashion through a block" do
      config = Rack::PageSpeed::Config.new do
        makes_it_look_good
        strips_naked
      end
      config.filters.should include_an_instance_of MakesItLookGood
      config.filters.should include_an_instance_of StripsNaked
    end

    # two specs below actually work with the optiosn hash based context too
    it "won't add the same filter twice" do
      config = Rack::PageSpeed::Config.new do
        makes_it_look_good
        makes_it_look_good
        strips_naked
      end
      config.filters.count.should == 2
    end

    it "calling a filter that requires storage without specifying one raises an error" do
      class NeedsStore < Rack::PageSpeed::Filter
        requires_store
      end
      expect { Rack::PageSpeed::Config.new do needs_store end }.to raise_error
    end
    
    it 'raises a NoSuchFilter error when a non-existing filter is called ' do
      expect { Rack::PageSpeed::Config.new do whateva :foo => 'bar' end }.to raise_error(Rack::PageSpeed::Config::NoSuchFilter)
    end
  end

  context 'setting a storage mechanism' do
    before { File.stub(:directory?).and_return(true) }
    
    it 'loads the appropriate class on request' do
      ::File.stub(:join).and_return(File.dirname(__FILE__) + '/fixtures/mock_store.rb')
      expect {
        Rack::PageSpeed::Config.new do
          store :mock
        end
      }.to change { Rack::PageSpeed::Store.const_defined?('Mock') }.from(false).to(true)
    end
  end
end
