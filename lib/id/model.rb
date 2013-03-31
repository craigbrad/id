module Id
  module Model

    attr_reader :data

    def initialize(data)
      @data = Hash[data.map { |k, v| [k.to_s, v] }]
    end

    def self.included(base)
      base.extend(Descriptor)
    end

    private

    def memoize(f, &b)
      instance_variable_get("@#{f}") || instance_variable_set("@#{f}", b.call)
    end

    module Descriptor
      def field(f, options={})
        Field.new(self, f, options).define
      end

      def has_one(f, options={})
        HasOne.new(self, f, options).define
      end

      def has_many(f, options={})
        HasMany.new(self, f, options).define
      end
    end

  end
end