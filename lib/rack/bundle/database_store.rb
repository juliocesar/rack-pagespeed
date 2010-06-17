require 'sequel'

class Rack::Bundle::DatabaseStore
  attr_accessor :db, :bundles
  
  def initialize url = ENV['DATABASE_URL']
    @db = Sequel.connect(url)
    @bundles = []
    create_table!
  end
  
  def find_bundle_by_hash hash
  end
    
  private
  def create_table!
    @db.create_table! 'rack_bundle' do
      primary_key :hash
      Text        :contents
    end
  end
end