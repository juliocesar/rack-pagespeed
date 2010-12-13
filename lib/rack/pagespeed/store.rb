require 'dalli'

class Rack::PageSpeed::Store
  class UnknownStorage < StandardError; end

  def initialize options
    mode, arg = options.is_a?(Hash) ? *[options.keys.first, options.values.first] : options
    @store = case mode.to_sym
            when :disk
              DiskStore.new arg
            when :memcached
              MemcachedStore.new arg
            else
              raise UnknownStorage, "Unknown storage method: #{mode}"
            end
  end
end