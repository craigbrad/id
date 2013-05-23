module Id
  module Model
    class Form
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend  ActiveModel::Naming

      def initialize(model)
        @model = model
      end

      def persisted?
        false
      end

      private

      def memoize(f, &b)
        instance_variable_get("@#{f}") || instance_variable_set("@#{f}", b.call)
      end

      attr_reader :model
    end
  end
end
