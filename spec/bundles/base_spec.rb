require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::Base do
  before do
    @bundle = Rack::Bundle::Base.new $jquery, $mylib
    Rack::Bundle::Base.stub(:joiner).and_return(";")
    Rack::Bundle::Base.stub(:extension).and_return("js")
  end
    
  it { should respond_to :files }  
  it { should respond_to :contents }
  it { should respond_to :hash }
  it { should respond_to :extension }  
  
  it 'makes the contents of one or more file(s) accessible via #contents' do
    @bundle.contents.should == [$jquery.contents, $mylib.contents].join(';')
  end

  it 'creates a MD5 hash out of the file names in the bundle' do    
    @bundle.hash.should == MD5.new([filename($jquery), filename($mylib)].join).to_s
  end
  
  it 'returns the path through which the bundle can be retrieved on #path' do
    @bundle.path.should == "/rack-bundle-#{@bundle.hash}.#{@bundle.extension}"
  end
  
  context "bundled instances" do
    before do
      @bundled = Rack::Bundle::Base.new_from_contents "moo foo"
    end
    
    it "are instances created from an existing bundle in storage" do
    end
    
    it "are initialized through #new_from_contents, with the contents as argument" do
      @bundled.is_a? Rack::Bundle::Base
    end
    
    it "have #contents" do
      @bundled.contents.should == "moo foo"
    end
    
    it "doesn't have #files" do
      @bundled.files.should be_empty
    end
  end
  
  
  it "should be equal to another bundle of the same hash and class" do
    another = Rack::Bundle::Base.new
    subject.should_receive(:hash).and_return('moo')
    another.should_receive(:hash).and_return('moo')
    subject.should == another
  end
end