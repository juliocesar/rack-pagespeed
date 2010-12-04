require 'rubygems'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ['-c', '-f nested', '-r ./spec/spec_helper']
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name                = "rack-pagespeed"
    gem.summary             = "Web page speed enhancements at the Rack level"
    gem.description         = "Web page speed enhancements at the Rack level"
    gem.email               = "julio@awesomebydesign.com"
    gem.homepage            = "http://github.com/juliocesar/rack-pagespeed"
    gem.authors             = "Julio Cesar Ody"
    gem.add_dependency      'nokogiri',   '1.2.1'
    gem.add_dependency      'nokogiri',   '1.4.4'
    gem.add_development_dependency 'rspec', '2.1.0'
  end
rescue LoadError
  puts 'Jeweler not available. gemspec tasks OFF.'
end