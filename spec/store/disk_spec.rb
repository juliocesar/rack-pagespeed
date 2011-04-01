require File.dirname(__FILE__) + '/../spec_helper'

describe 'disk storage' do
  before :all do
    Rack::PageSpeed::Config
    @store = Rack::PageSpeed::Store::Disk.new
  end

  context 'initializing' do
    it "sets the path to the value passed to the constructor" do
      Rack::PageSpeed::Store::Disk.new(Fixtures.path).instance_variable_get(:@path).should == Fixtures.path
    end
    it "defaults to the system's TMP dir if nothing is passed to the constructor" do
      Rack::PageSpeed::Store::Disk.new.instance_variable_get(:@path).should == Dir.tmpdir
    end
    it "raises ArgumentError if the path passed to the constructor is not a directory" do
      expect { Rack::PageSpeed::Store::Disk.new 'unpossible sir' }.to raise_error(ArgumentError)
    end
  end

  context 'writing' do
    it "writes to disk with a Hash-like syntax" do
      @store['omg'] = "value"
      File.read("#{Dir.tmpdir}/bundle-omg").should == "value"
    end
  end

  context 'reading' do
    it "reads from disk with a Hash-like syntax" do
      File.open("#{Dir.tmpdir}/bundle-hola", 'w') { |file| file << "Hola mundo" }
      @store['hola'].should == "Hola mundo"
    end
  end
end