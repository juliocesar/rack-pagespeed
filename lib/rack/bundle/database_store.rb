require 'sequel'

class Rack::Bundle::DatabaseStore
  attr_accessor :db, :bundles
  
  def initialize url = ENV['DATABASE_URL']
    @db = Sequel.connect(url)
    @bundles = []
    create_table!
  end
  
  def find_bundle_by_hash hash
    return nil unless result = @db[:rack_bundle].where(:hash => hash).first
    result[:type] == 'js' ? 
      Rack::Bundle::JSBundle.new(result[:contents]) :
      Rack::Bundle::CSSBundle.new(result[:contents])
  end
  
  def save!
    @bundles.each do |bundle|
      unless has_bundle?(bundle)
        @db[:rack_bundle].insert :contents => bundle.contents, 
          :hash => bundle.hash,
          :type => bundle.is_a?(Rack::Bundle::JSBundle) ? 'js' : 'css'
      end
    end
  end
  
  def has_bundle? bundle
    not find_bundle_by_hash(bundle.hash).nil?
  end
    
  private
  def create_table!
    @db.create_table! 'rack_bundle' do
      String  :hash
      String  :type
      Text    :contents
      
      index   :hash
    end
  end
end