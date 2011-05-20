$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'rubygems'
require 'rspec'
require 'fileutils'
require 'dalli'
require 'redis'
require 'rack/pagespeed'
require 'rack/pagespeed/store/disk'
require 'rack/pagespeed/store/memcached'
require 'rack/pagespeed/store/redis'
require 'fileutils'
require 'tmpdir'
require 'ostruct'

def fixture name
  File.read(File.join(Fixtures.path, name))
end

module Apps
  class << self
    def complex
      lambda { |env| [200, { 'Content-Type' => 'text/html' }, [fixture('complex.html')]] }
    end

    def plain_text
      lambda { |env| [200, { 'Content-Type' => 'text/plain' }, ['plain texto']] }
    end
  end
end

Fixtures = OpenStruct.new unless defined?(Fixtures)
Fixtures.path = File.join(File.dirname(__FILE__), 'fixtures')
Fixtures.complex = Nokogiri::HTML(fixture('complex.html'))
Fixtures.noscripts = Nokogiri::HTML(fixture('noscripts.html'))
Fixtures.noexternalcss = Nokogiri::HTML(fixture('noexternalcss.html'))
Fixtures.styles = Nokogiri::HTML(fixture('styles.html'))


def include_an_instance_of klass    
  simple_matcher("have an instance of #{klass.to_s}") do |given|
    given.select { |entry| entry.is_a? klass }.any?
  end
end

RSpec::Matchers.define :include_an_instance_of do |klass|
  match do |given|
    given.select { |entry| entry.is_a? klass }.count > 0
  end
end

RSpec.configure do |config|
  # Restore fixtures' original state
  config.before :each do
    Fixtures.complex = Nokogiri::HTML(fixture('complex.html'))
    Fixtures.noscripts = Nokogiri::HTML(fixture('noscripts.html'))
    Fixtures.noexternalcss = Nokogiri::HTML(fixture('noexternalcss.html'))
    Fixtures.styles = Nokogiri::HTML(fixture('styles.html'))
  end
end

