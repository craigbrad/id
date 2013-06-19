module Id
  module Model
    module Descriptor

      def field(f, options={})
        Field.new(self, f, options).define
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

      def form &block
        form_object.send :instance_exec, &block
      end

      def form_object
        base = self
        @form_object ||= Class.new(Form) do
          instance_exec do
            define_singleton_method :model_name do
              ActiveModel::Name.new(self, nil, base.name)
            end
          end
        end
      end

      def to_proc
        ->(data) { new data }
      end

      private

      def builder_class
        @builder_class ||= Class.new { include Builder }
      end

    end
  end
end
