module Id
  module Model
    attr_reader :data

    def initialize(data = {})
      @data = Hashifier.hashify(data)
    end

    def set(values)
      self.class.new(data.merge(Hashifier.hashify(values)))
    end

    def unset(*keys)
      self.class.new(data.except(*keys.map(&:to_s)))
    end

    def eql? other
      other.is_a?(Id::Model) && other.data.eql?(self.data)
    end
    alias_method :==, :eql?

    def hash
      data.hash
    end

    private

    def self.included(base)
      base.extend(Descriptor)
    end

    def memoize(f, &b)
      instance_variable_get("@#{f}") || instance_variable_set("@#{f}", b.call)
    end

    module Descriptor

      def field(f, options={})
        (options[:optional] ? FieldOption : Field).new(self, f, options).define
      end

      def has_one(f, options={})
        (options[:optional] ? HasOneOption : HasOne).new(self, f, options).define
      end

      def has_many(f, options={})
        HasMany.new(self, f, options).define
      end

      def compound_field(f, fields, options={})
        CompoundField.new(self, f, fields, options).define
      end

      def builder
        builder_class.new(self)
      end

      def to_proc
        ->(data){ new data }
      end

      private

      def builder_class
        @builder_class ||= Class.new { include Builder }
      end
    end

  end
end
