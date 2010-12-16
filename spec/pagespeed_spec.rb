require File.dirname(__FILE__) + '/spec_helper'

describe 'rack-pagespeed' do
  before do
    @pagespeed = Rack::PageSpeed.new Apps.complex, :public => Fixtures.path, :store => {}
    @env = Rack::MockRequest.env_for '/'
  end

  context 'parsing the response body' do
    before do
      status, headers, @response = @pagespeed.call @env
    end

    it "doesn't happen unless the response is not HTML" do
      pagespeed = Rack::PageSpeed.new Apps.plain_text, :public => Fixtures.path
      pagespeed.call @env
      pagespeed.instance_variable_get(:@document).should be_nil
    end

    it "only happens if the response is HTML" do
      pagespeed = Rack::PageSpeed.new Apps.complex, :public => Fixtures.path
      pagespeed.call @env
      pagespeed.instance_variable_get(:@document).should_not be_nil
    end
  end

  context 'configuration' do
    before do
      class BarFilter < Rack::PageSpeed::Filters::Base; end
      class FooFilter < Rack::PageSpeed::Filters::Base; end
    end

    it "takes an options hash which gets passed to it's config" do
      @pagespeed.config.public.should == Fixtures.path
    end

    it "takes a block which gets passed to it's config" do
      pagespeed = Rack::PageSpeed.new Apps.complex, :public => Fixtures.path do
        bar_filter
      end
      pagespeed.config.filters.first.should be_a BarFilter
    end

    it "passes the constructor's options down to the filters" do
      pagespeed = Rack::PageSpeed.new Apps.complex, :public => Fixtures.path, :store => {} do
        foo_filter
      end
      pagespeed.config.filters.first.options.should == {:public => Fixtures.path, :store => {}}
    end

  end

  context 'dispatching filters' do
    before do
      $foo = []
      class AddsFoo < Rack::PageSpeed::Filters::Base; def execute! document; $foo << 'foo' end; end
      class AddsBar < Rack::PageSpeed::Filters::Base; def execute! document; $foo << 'bar' end; end
      @pagespeed = Rack::PageSpeed.new Apps.complex, :public => Fixtures.path do
        adds_foo
        adds_bar
      end
    end

    it "calls #execute! on each filter it finds in it's config" do
      @pagespeed.call @env
      $foo.should == ['foo', 'bar']
    end
  end

  context 'responding to /rack-pagespeed-* requests' do
    context 'for assets that it finds in store' do
      before do
        store = @pagespeed.config.store
        store['12345.js'] = 'Little poney'
        @status, @headers, @response = @pagespeed.call Rack::MockRequest.env_for '/rack-pagespeed-12345.js'
      end

      it "responds with the contents in store that match the asset unique id" do
        @response.to_s.should == 'Little poney'
      end
    
      it "responds with the appropriate MIME type for the asset stored" do
        @headers['Content-Type'].should == 'application/javascript'
      end
    
      it "responds with HTTP 200" do
        @status.should == 200
      end
    end
  end
  
  context "for assets that can't be found in store" do
    before do
      @status, @headers, @response = @pagespeed.call Rack::MockRequest.env_for '/rack-pagespeed-nonexistent.css'
    end
    
    it "responds with HTTP 404" do
      @status.should == 404
    end
  end
end
