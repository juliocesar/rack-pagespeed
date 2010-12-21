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
      
      def requires_store
        instance_eval do
          def new options = {}
            options[:store] ? super(options) : false
          end
        end
      end

      def name _name = nil
        _name ? @name = _name : @name ||= underscore(to_s)
      end
      
      def priority _number = nil
        _number ? @priority = _number.to_i : @priority
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
      path = ::File.join(options[:public], node[node.name == 'script' ? 'src' : 'href'])
      ::File.open path if ::File.exists? path
    end
  end
  # shortcut
  Rack::PageSpeed::Filter = Base
end