module Rack::PageSpeed::Filters
  class Base
    attr_reader :document, :options
    @@subclasses = []

    def initialize options = {}
      @options = options
    end

    class << self
      def inherited klass
        @@subclasses << klass
      end

      def available_filters
        @@subclasses
      end

      def method name = nil
        name ? @method = name : @method ||= underscore(to_s)
      end

      private
      def underscore word
        word.split('::').last.
        gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
        gsub(/([a-z\d])([A-Z])/,'\1_\2').
        tr("-", "_").
        downcase
      end
    end

    private
    def file_for node
      case node.name
      when 'script'
        ::File.open ::File.join(options[:public], node['src'])
      when 'link'
        ::File.open ::File.join(options[:public], node['href'])
      end
    end
  end
end