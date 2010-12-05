require File.dirname(__FILE__) + '/spec_helper'

describe 'rack-pagespeed configuration' do
  context 'options hash based' do
    it 'enables filters included in a :filters options' do
      pagespeed = Rack::PageSpeed.new page, :filters => [:inline_javascript]
      pagespeed.config.filters.should include(:inline_javascript)
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
