#!/bin/ruby

Gem::Specification.new do |s|
  s.author = "Julio Cesar Ody"
  s.email = "julio@awesomebydesign.com"
  s.homepage = "http://github.com/juliocesar/rack-pagespeed"
  
  s.description = "Web page speed optimizations at the Rack level"
  s.summary = "Increased speeds for your web app's needs" # hehe =p 
  
  s.require_paths = ["lib"]
  
  s.name = File.basename(__FILE__, ".gemspec")
  s.version = File.read("VERSION")
  # VERSIONING
  # Some people like to use a YAML file to display the version, some like CSV,
  # others might just add a constant set to a version string, some (Rack) might
  # even have an array splitting the version into parts.
  # Just edit the above line appropriately.
  # An easy thing to do is set a constant within your app to a version string
  # and use it in here
  
  # Add directories you *might* use in ALL projects.
  s.files = [File.basename(__FILE__)] + Dir['lib/**/*'] + Dir['bin/**/*'] + 
                                        Dir['test/**/*'] + Dir['spec/**/*'] + 
                                        Dir['examples/**/*']
  
  # Add files you *might* use in ALL projects!
  %W{Gemfile.lock README.* README Rakefile VERSION *.thor LICENSE LICENSE.*}.each do |file|
    s.files.unshift(file) if File.exists?(file)
  end
  
  # Add files you *might* use in ALL projects!
  %W{README.* README VERSION LICENSE LICENSE.*}.each do |file|
    (s.extra_rdoc_files ||= []).unshift(file) if File.exists?(file)
  end
  
  # If you only specify one application file in executables, that file becomes 
  # the default executable. Therefore, you only need to specify this value if you 
  # have more than one application file. 
  if s.executables.length > 1
    if exe = s.executables.find { |e| e.include?(File.basename(__FILE__, ".gemspec")) }
      s.default_executable = exe
    else
      raise(Exception, "Couldn't automatically figure out the default_executable")
    end
  end
  
  s.test_files = Dir['test/**/*'] + Dir['spec/**/*'] + Dir['examples/**/*']
  
  # Add dependencies here:
  # This is required for your gem to work:
  # s.add_dependency("some_required_gem", "~> 0.1.0")
  # This is required for developers to build and test your gem:
  # s.add_development_dependency("some_development_gem", "~> 0.1.0")
  
  s.add_dependency("nokogiri")
  s.add_dependency("jsmin")
  s.add_dependency("dalli")
  
  s.add_development_dependency("rack", "~> 0.2.1")
  s.add_development_dependency("rspec", "~> 2.3.0")
  s.add_development_dependency("steak", "~> 2.3.0")
  s.add_development_dependency("capybara", "~> 0.4.0")
  s.add_development_dependency("redis")
  s.add_development_dependency("memcached")
  
end

# Now run the following command:
# 
#   $ echo -e "source :rubygems\ngemspec" > Gemfile
# 
# This makes Bundler pull in this gemspec's dependencies so you don't have
# to write them twice. Development dependencies are grouped under :development.
# 
#   $ bundle install
# 
# This means.. ALWAYS ONLY SPECIFY DEPENDENCIES WITHIN YOUR GEMSPEC!

#source :rubygems

#gem 'rack'    # Just let it work with latest. If the API breaks, I'll fix it
#gem 'nokogiri'
#gem 'jsmin'
#gem 'dalli'

#group :test do
#  gem 'rspec',    '2.3.0'
#  gem 'steak',    '1.0.0'
#  gem 'capybara', '0.4.0'
#  gem 'redis'
#  gem 'memcached'
#end

