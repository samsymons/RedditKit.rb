module RedditKit

  # A base class for RedditKit's model objects, automatically generating attribute and predicate methods.
  class Base

    attr_reader :attributes

    class << self

      def attr_reader(*attrs)
        attrs.each do |attr|
          define_attribute_method(attr)
          define_predicate_method(attr)
        end
      end

      private

      def define_attribute_method(method)
        define_method(method) do
          memoize(method) do
            @attributes[method]
          end
        end
      end

      def define_predicate_method(method)
        define_method(:"#{method}?") do
          !!@attributes[method]
        end
      end

    end

    def initialize(attributes = {})
      kind = attributes[:kind]
      data = attributes[:data]

      @attributes = data || {}
      @attributes[:kind] = kind
    end

    def [](method)
      send(method.to_sym)
    rescue NoMethodError
      nil
    end

    private

    def memoize(key, &block)
      ivar = :"@#{key}"
      return instance_variable_get(ivar) if instance_variable_defined?(ivar)

      result = block.call
      instance_variable_set(ivar, result)
    end

  end
end
