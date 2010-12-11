require File.dirname(__FILE__) + '/../spec_helper'

describe 'the base filter class' do
  before  { @base = Rack::PageSpeed::Filters::Base.new(:foo => 'bar') }
  
  it 'when instancing, it optionally takes an options hash as argument' do
    @base.options[:foo].should == 'bar'
  end
  
  it 'when subclassing, it adds the new class to the #available_filters list' do
    class Moo < Rack::PageSpeed::Filters::Base; end
    Rack::PageSpeed::Filters::Base.available_filters.should include(Moo)
  end

  context 'the #name declaration, which can be used to declare a name which the filter can be called upon' do
    it 'can be called from inside the class' do
      class Boo < Rack::PageSpeed::Filters::Base
        name 'mooers'
      end
      Boo.name.should == 'mooers'
    end

    it 'defaults to the class name if not called' do
      class BananaSmoothie < Rack::PageSpeed::Filters::Base; end
      BananaSmoothie.name.should == 'banana_smoothie'
    end
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
