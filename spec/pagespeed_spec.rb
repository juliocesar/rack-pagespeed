require File.dirname(__FILE__) + '/spec_helper'

describe 'rack-pagespeed' do
  before do
    @pagespeed = Rack::PageSpeed.new page, :public => FIXTURES_PATH
  end
end
