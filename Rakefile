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
    gem.add_development_dependency 'rake'
    gem.add_development_dependency 'rspec', '2.6.0'
    gem.add_development_dependency 'capybara', '1.1.0'
    gem.add_development_dependency 'jeweler', '~> 1.8.3'
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

SPEC_DIR = File.expand_path(File.join("..", "spec"), __FILE__)
DB_DIR = File.join(SPEC_DIR, "db")

REDIS_CNF = File.join(SPEC_DIR, "redis_test.conf")
REDIS_PID = File.join(SPEC_DIR, "db", "redis.pid")
REDIS_LOCATION = ENV['REDIS_LOCATION']

MEMCACHE_PID = File.join(SPEC_DIR, "db", "memcache.pid")
MEMCACHE_LOCATION = ENV['MEMCACHE_LOCATION']

desc "Create the DB_DIR"
task :create_db_dir do
  unless Dir.exists?(DB_DIR)
    Dir.mkdir(DB_DIR)
  end
end

desc "Start the Redis server"
task :start_redis do
  redis_running = \
    begin
      File.exists?(REDIS_PID) && Process.kill(0, File.read(REDIS_PID).to_i)
    rescue Errno::ESRCH
      FileUtils.rm REDIS_PID
      false
    end
  
  if REDIS_LOCATION
    system "#{REDIS_LOCATION}/redis-server #{REDIS_CNF}" unless redis_running
  else
    system "redis-server #{REDIS_CNF}" unless redis_running
  end
end

desc "Stop the Redis server"
task :stop_redis do
  if File.exists?(REDIS_PID)
    begin
      Process.kill "INT", File.read(REDIS_PID).to_i
    rescue Errno::ESRCH
    ensure 
      FileUtils.rm REDIS_PID
    end
  end
end

desc "Start the memcached server"
task :start_memcached do
  memcached_running = \
    begin
      File.exists?(MEMCACHE_PID) && Process.kill(0, File.read(MEMCACHE_PID).to_i)
    rescue Errno::ESRCH
      FileUtils.rm MEMCACHE_PID
      false
    end
  
  if MEMCACHE_LOCATION
    system "#{MEMCACHE_LOCATION}/memcached -d -P #{MEMCACHE_PID}" unless memcached_running
  else
    system "memcached -d -P #{MEMCACHE_PID}" unless memcached_running
  end
end

desc "Stop the memcached server"
task :stop_memcached do
  if File.exists?(MEMCACHE_PID)
    begin
      Process.kill "INT", File.read(MEMCACHE_PID).to_i
    rescue Errno::ESRCH
    ensure 
      FileUtils.rm MEMCACHE_PID
    end
  end
end

desc "Run specs and manage server start/stop"
task :spec_with_services => [:create_db_dir, :start_redis, :start_memcached, :spec, :stop_redis, :stop_memcached]

task :default => :spec
