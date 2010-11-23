require 'rubygems'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new do |t| 
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ['-c', '-f nested', '-r ./spec/spec_helper']
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name                = "rack-bundle"
    gem.summary             = "Javascript and CSS bundling at the Rack level"
    gem.description         = "Javascript and CSS bundling at the Rack level"
    gem.email               = "julio.ody@gmail.com"
    gem.homepage            = "http://github.com/juliocesar/rack-bundle"
    gem.authors             = "Julio Cesar Ody"
    gem.add_dependency      'rack',       '= 1.2.1'
    gem.add_dependency      'nokogiri',   '= 1.4.4'    
    gem.add_development_dependency 'rspec', '= 2.1.0'
    gem.add_development_dependency 'rake',  '>= 0.8.7'
  end
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end