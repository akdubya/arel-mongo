module Arel
  module Attributes
    class Generic < Attribute
      def type_cast(value)
        value
      end
    end
  end
end