require File.dirname(__FILE__) + '/spec_helper'

describe 'rack-pagespeed' do
  before do
    @pagespeed  = Rack::PageSpeed.new page, :public => FIXTURES_PATH
    @env        = Rack::MockRequest.env_for '/'
  end

  context 'parsing the response body' do
    before do
      status, headers, @response = @pagespeed.call @env
    end

    it "doesn't happen unless the response is not HTML" do
      pagespeed = Rack::PageSpeed.new plain_text, :public => FIXTURES_PATH
      pagespeed.call @env
      pagespeed.instance_variable_get(:@document).should be_nil
    end

    it "only happens if the response is HTML" do
      pagespeed = Rack::PageSpeed.new page, :public => FIXTURES_PATH
      pagespeed.call @env
      pagespeed.instance_variable_get(:@document).should_not be_nil
    end
  end
end
