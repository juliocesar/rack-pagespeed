require File.dirname(__FILE__) + '/../spec_helper'

describe 'the inline_javascript filter' do
  context "executing" do
    before :each do
      @inliner = Rack::PageSpeed::Filters::InlineJavaScript.new DOCUMENT
      @inliner.execute!
    end

    it 'inlines JavaScripts that are smaller than 2kb in size by default' do
      DOCUMENT.
    end
    it 'takes a size threshold parameter via :minimum_size'
  end
end
