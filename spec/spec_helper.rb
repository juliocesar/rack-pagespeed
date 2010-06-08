$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'spec'
require 'rack/bundle'

FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')

def fixture name
  File.read(File.join(FIXTURES_PATH, name))
end

def index_page
  lambda { |env| Rack::Response.new(fixture('index.html')).finish }
end

def plain_text
  lambda { |env| Rack::Response.new('plain texto', 200, 'Content-Type' => 'text/plain').finish }
end


Spec::Runner.configure do 
  $jquery, $mylib = fixture('jquery-1.4.1.min.js'), fixture('mylib.js')
  $reset, $screen = fixture('reset.css'), fixture('screen.css')
  $index          = fixture('index.html')
  $doc            = Nokogiri::HTML($index)
end