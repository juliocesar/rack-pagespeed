require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Bundle::DatabaseStore do
  # Getting onto it
  it 'does the same FileSystemStore does except it persists to a database using Sequel'
end