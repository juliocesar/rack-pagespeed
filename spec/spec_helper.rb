$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'spec'
require 'rack/bundle'

def fixture name
  File.read(File.join(File.dirname(__FILE__), 'fixtures', name))
end

Spec::Runner.configure do 
  @jquery, @mylib = fixture('jquery-1.4.1.min.js'), fixture('mylib.js')
end