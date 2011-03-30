lib = File.join(File.dirname(__FILE__), '..')
module Rack::PageSpeed::Store; end
require "#{lib}/store/disk"
require "#{lib}/store/memcached"
require "#{lib}/store/redis"

  