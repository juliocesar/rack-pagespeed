lib = File.join(File.dirname(__FILE__), '..')
require "#{lib}/store/disk"
require "#{lib}/store/memcached"
require "#{lib}/filters/base.rb"
require "#{lib}/filters/inline_javascript.rb"
require "#{lib}/filters/inline_css.rb"