module Arel
  module Attributes
    class Time < Attribute
      def type_cast(value)
        return if value.blank?
        return value if value.kind_of?(::Time)
        return value.to_time if value.respond_to?(:to_time)
        ::Time.parse(value.to_s)
      end
    end
  end
end