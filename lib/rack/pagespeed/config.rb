class Rack::PageSpeed::Config
  class NoSuchFilterError < RuntimeError; end
  
  attr_reader :filters
  
  def initialize options
    @filters, @options = [], options
    filters_to_methods
    enable_filters_from_options
  end
  
  def enable_filters_from_options
    return nil unless @options[:filters]
    case @options[:filters]
      when Array  then @options[:filters].map { |filter| self.send filter }
      when Hash   then @options[:filters].each { |filter, options| self.send filter, options }
    end
  end
  
  private
  def filters_to_methods
    (Rack::PageSpeed::Filters.constants - ['Base']).each do |filter|
      klass = Rack::PageSpeed::Filters.const_get(filter)
      (class << self; self; end).send :define_method, klass.method do |*options|
        @filters << klass.new(@document, options.any? ? @options.merge(*options) : @options)
      end
    end
  end
end