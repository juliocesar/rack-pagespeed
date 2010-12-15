class Rack::PageSpeed::Config
  class NoSuchFilter < StandardError; end
  class NoSuchStorageMechanism < StandardError; end  
  load "#{::File.dirname(__FILE__)}/store/all.rb"
  
  attr_reader :filters, :options

  def initialize options = {}, &block
    @filters, @options, @public = [], options, options[:public]
    raise ArgumentError, ":public needs to be a directory" unless File.directory? @public.to_s
    filters_to_methods
    enable_filters_from_options
    enable_store_from_options
    instance_eval &block if block_given?
  end
  
  def store type, args = nil
    case type
    when :disk
      @options[:store] = Rack::PageSpeed::Store::Disk.new args
    when :memcached
      @options[:store] = Rack::PageSpeed::Store::Memcached.new args
    when {}
      @options[:store] = {} # simple in-memory store
    else
      raise NoSuchStorageMechanism, "No such storage mechanism: #{type}"
    end
  end

  def method_missing filter
    raise NoSuchFilterError, "No such filter \"#{filter}\". Available filters: #{(Rack::PageSpeed::Filters::Base.available_filters).join(', ')}"
  end

  private
  def enable_store_from_options
    return false unless @options[:store]
    case @options[:store]
      when Array then store *@options[:store]
      when Hash
        @options[:store] == {} ? store({}) : store(*@options[:store].to_a.first)
    end
  end
  
  def enable_filters_from_options
    return false unless @options[:filters]
    case @options[:filters]
      when Array  then @options[:filters].map { |filter| self.send filter }
      when Hash   then @options[:filters].each { |filter, options| self.send filter, options }
    end
  end

  def filters_to_methods
    Rack::PageSpeed::Filters::Base.available_filters.each do |klass|
      (class << self; self; end).send :define_method, klass.name do |*options|
        instance = klass.new(options.any? ? @options.merge(*options) : @options)
        @filters << instance if instance and !@filters.select { |k| k.is_a? instance.class }.any?
      end
    end
  end
  
  def filters_include_a? filters, klass
    filters.select { |k| k.is_a? klass.class }.any?
  end
end