require 'date'

module Arel
  module Attributes
    class Date < Attribute
      def type_cast(value)
        return value if value.kind_of?(::Date)
        return nil if value.blank?
        ::Date.parse(value.to_s)
      end

      def mongo_value(value)
        return unless value = type_cast(value)
        value.to_time
      end
    end
  end
end