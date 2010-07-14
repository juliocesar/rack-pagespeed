$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'spec'
require 'fileutils'
require 'rack/bundle'
require 'rack/bundle/bundles/base'
require 'tmpdir'

include Rack::Utils
alias :h :escape_html

FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')

def fixture name
  File.open(File.join(FIXTURES_PATH, name))
end

def make_js_bundle
  Rack::Bundle::JSBundle.new $jquery, $mylib
end

def make_css_bundle
  @bundle = Rack::Bundle::CSSBundle.new $reset, $screen
end

def filename file
  File.basename file.path
end

def index_page
  lambda { |env| [200, { 'Content-Type' => 'text/html' }, [fixture('index.html')]] }
end

def simple_page
  lambda { |env| [200, { 'Content-Type' => 'text/html' }, [fixture('simple.html')]] }
end

def plain_text
  lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['plain texto']] }
end

Spec::Runner.configure do |config|
  $jquery, $mylib = fixture('jquery-1.4.1.min.js'), fixture('mylib.js')
  $reset, $screen = fixture('reset.css'), fixture('screen.css')
  $index          = fixture('index.html')
  $doc            = Nokogiri::HTML($index)
  config.after(:all) do
    `rm -f #{FIXTURES_PATH}/rack-bundle*`
  end
end