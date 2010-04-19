require 'active_support/core_ext/array/wrap'

module Arel
  module Attributes
    class Array < Attribute
      def type_cast(value)
        return value if value.kind_of?(::Array)
        ::Array.wrap(value)
      end
    end
  end
end