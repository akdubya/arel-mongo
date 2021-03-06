module Arel
  module Attributes
    class Regexp < Attribute
      def type_cast(value)
        return value if value.nil? || value.kind_of?(::Regexp)
        ::Regexp.new(value)
      end
    end
  end
end