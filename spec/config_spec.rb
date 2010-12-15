require File.dirname(__FILE__) + '/spec_helper'

describe 'rack-pagespeed configuration' do
  before do
    class StripsNaked < Rack::PageSpeed::Filters::Base; end
    class MakesItLookGood < Rack::PageSpeed::Filters::Base; end
  end

  context 'when instancing a new object' do
    it 'creates methods for each filter class found in Rack::PageSpeed::Filters::Base.available_filters' do
      Rack::PageSpeed::Config.new(:public => Dir.tmpdir).should respond_to :strips_naked
    end

    it "requires a :public parameter pointing to the app's public directory" do
      expect { Rack::PageSpeed::Config.new("foo" => "bar") }.to raise_error(ArgumentError)
    end
  end

  context 'enabling filters, options hash based' do
    context 'options[:filters]' do
      before { File.stub(:directory?).and_return(true) }

      it "if it's an array, it enables filters listed in it with their default options" do
        config = Rack::PageSpeed::Config.new :filters => [:makes_it_look_good]
        config.filters.first.should be_a MakesItLookGood
      end

      it "if it's a hash, it let's you pass options to the filters logically" do
        config = Rack::PageSpeed::Config.new :filters => {:makes_it_look_good => {:test => 6000}}
        filter = config.filters.first
        filter.should be_a MakesItLookGood
        filter.options[:test].should == 6000 # yeah, 2 assertions, bad, bad
      end
    end

    it 'raises a NoSuchFilterError when a non-existing filter is passed to :filters' do
      expect { Rack::PageSpeed.new page, :filters => [:whoops!] }.to raise_error
    end
  end

  context 'enabling filters, block/DSL based' do
    before { File.stub(:directory?).and_return(true) }

    it "let's you invoke filter names in a DSL-like fashion through a block" do
      config = Rack::PageSpeed::Config.new do
        makes_it_look_good
        strips_naked
      end
      config.filters.first.should be_a MakesItLookGood
      config.filters.last.should be_a StripsNaked
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

    it "won't add a filter if it's call returns false" do
      class NeedsStore < Rack::PageSpeed::Filters::Base
        requires_store
      end
      config = Rack::PageSpeed::Config.new do needs_store end
      config.filters.should be_empty
    end
  end

  context 'setting a storage mechanism' do
    before { File.stub(:directory?).and_return(true) }

    context 'through the hash options' do
      context ':disk => "directory path" sets to disk storage, with a specific path' do
        before  { @config = Rack::PageSpeed::Config.new :store => { :disk => FIXTURES_PATH } }
        subject { @config.options[:store] }
        specify { should be_a Rack::PageSpeed::Store::Disk }
        specify { subject.instance_variable_get(:@path).should == FIXTURES_PATH }
      end
      context ":disk sets to disk storage, in the system's temp dir" do
        before  { @config = Rack::PageSpeed::Config.new :store => :disk }
        subject { @config.options[:store] }
        specify { should be_a Rack::PageSpeed::Store::Disk }
        specify { subject.instance_variable_get(:@path).should == Dir.tmpdir }
      end
      context 'sets to memcache storage if :memcache => "server address/port"' do
        before  { @config = Rack::PageSpeed::Config.new :store => { :memcached => 'localhost:11211' } }
        subject { @config.options[:store] }
        specify { should be_a Rack::PageSpeed::Store::Memcached }
        specify { subject.instance_variable_get(:@client).servers.first.should =~ /localhost:11211/ }
      end
      context 'sets to memcache storage, 127.0.0.1:11211 if :memcache"' do
        before  { @config = Rack::PageSpeed::Config.new :store => :memcached }
        subject { @config.options[:store] }
        specify { should be_a Rack::PageSpeed::Store::Memcached }
        specify { subject.instance_variable_get(:@client).servers.first.should =~ /127.0.0.1:11211/ }
      end
      context "raises NoSuchStorageMechanism for weird stuff" do
        specify { expect { Rack::PageSpeed::Config.new :store => :poo }.to raise_error(Rack::PageSpeed::Config::NoSuchStorageMechanism) }
      end
    end

    context 'through a block passed to the initializer' do
      context 'to disk storage, in a specific path if :disk => "some directory path"' do
        before do
          @config = Rack::PageSpeed::Config.new do
            store :disk => FIXTURES_PATH
          end
        end
        subject { @config.options[:store] }
        specify { should be_a Rack::PageSpeed::Store::Disk }
        specify { subject.instance_variable_get(:@path).should == FIXTURES_PATH }
      end
      context ":disk sets to disk storage, in the system's temp dir" do
        before do
          @config = Rack::PageSpeed::Config.new do
            store :disk
          end
        end
        subject { @config.options[:store] }
        specify { should be_a Rack::PageSpeed::Store::Disk }
        specify { subject.instance_variable_get(:@path).should == Dir.tmpdir }
      end
      context 'sets to memcache storage if :memcache => "server address/port"' do
        before do
          @config = Rack::PageSpeed::Config.new do
            store :memcached => 'localhost:11211'
          end
        end
        subject { @config.options[:store] }
        specify { should be_a Rack::PageSpeed::Store::Memcached }
        specify { subject.instance_variable_get(:@client).servers.first.should =~ /localhost:11211/ }
      end
      context 'sets to memcache storage, localhost:11211 if :memcache"' do
        before do
          @config = Rack::PageSpeed::Config.new do
            store :memcached
          end
        end
        subject { @config.options[:store] }
        specify { should be_a Rack::PageSpeed::Store::Memcached }
        specify { subject.instance_variable_get(:@client).servers.first.should =~ /127.0.0.1:11211/ }
      end
      context "raises NoSuchStorageMechanism for weird stuff" do
        specify do
          expect { Rack::PageSpeed::Config.new do store :poo end }.to raise_error(Rack::PageSpeed::Config::NoSuchStorageMechanism)
        end
      end
    end
  end
end
