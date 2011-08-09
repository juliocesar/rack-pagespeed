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
    gem.summary             = "Web page speed optimizations at the Rack level"
    gem.description         = "Web page speed optimizations at the Rack level"
    gem.email               = "julio@awesomebydesign.com"
    gem.homepage            = "http://github.com/juliocesar/rack-pagespeed"
    gem.authors             = "Julio Cesar Ody"
    gem.add_dependency      'nokogiri'
    gem.add_dependency      'rack'
    gem.add_dependency      'memcached'
    gem.add_dependency      'mime-types'
    gem.add_dependency      'jsmin'
    gem.add_development_dependency 'rspec', '2.6.0'
    gem.add_development_dependency 'capybara', '1.1.0'
  end
rescue LoadError
  puts 'Jeweler not available. gemspec tasks OFF.'
end

namespace :spec do
  desc "Runs specs on Ruby 1.8.7 and 1.9.2"
  task :rubies do
    system "rvm 1.8.7-p174,1.9.2 specs"
  end
end
