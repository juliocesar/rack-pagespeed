$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rspec'
require 'fileutils'
require 'rack/pagespeed'
require 'tmpdir'

include Rack::Utils
alias :h :escape_html

def fixture name
  File.open(File.join(FIXTURES_PATH, name)).readlines.join
end

def page
  lambda { |env| [200, { 'Content-Type' => 'text/html' }, [fixture('complex.html')]] }
end

def plain_text
  lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['plain texto']] }
end

def mock_store
  Class.new do
    def initialize; @db = {}; end
    def [] key; @db[key]; end
    def []= key, value; @db[key] = value; end
  end.new
end

FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')
FIXTURES = Struct.new('HTML', :complex, :noscripts, :noexternalcss, :styles).new(
  Nokogiri::HTML(fixture('complex.html')),
  Nokogiri::HTML(fixture('noscripts.html')),
  Nokogiri::HTML(fixture('noexternalcss.html')),
  Nokogiri::HTML(fixture('styles.html'))
)

RSpec.configure do |config|
  # Restore fixtures' original state
  config.before :each do
    FIXTURES.complex = Nokogiri::HTML(fixture('complex.html'))
    FIXTURES.noscripts = Nokogiri::HTML(fixture('noscripts.html'))
    FIXTURES.noexternalcss = Nokogiri::HTML(fixture('noexternalcss.html'))
    FIXTURES.styles = Nokogiri::HTML(fixture('styles.html'))
  end
end

