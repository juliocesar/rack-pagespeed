require File.join(File.dirname(__FILE__), 'spec_helper')

describe Rack::Bundle do
  it 'defaults to FileSystemStore for storage' do
    subject.engine.is_a? Rack::Bundle::FileSystemStore
  end
    
  context 'when parsing' do
    it "parses the response only if it's MIME type is text/html"
    it "extracts all external links to Javascript files and instances a JSBundle with them"
    it "extracts all links to CSS and instances a CSSBundle with them"
    it "bundles all found Javascripts together and compresses them"
    it "bundles all found stylesheets together"
    it "stores the bundle(s) using the currently available engine"
  end
end