module Arel
  module Attributes
    class Symbol < Attribute
      def type_cast(value)
        return unless value
        value.to_sym
      end
    end
  end
end