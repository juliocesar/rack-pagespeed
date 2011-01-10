lib = File.join(File.dirname(__FILE__), '..')
require "#{lib}/filters/base.rb"
require "#{lib}/filters/inline_javascripts.rb"
require "#{lib}/filters/inline_css.rb"
require "#{lib}/filters/combine_javascripts.rb"
require "#{lib}/filters/combine_css.rb"
require "#{lib}/filters/minify_javascripts.rb"
require "#{lib}/filters/inline_images.rb"
