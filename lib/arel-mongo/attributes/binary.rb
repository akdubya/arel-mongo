module Arel
  module Attributes
    module BSON
      class Binary < Attribute
        def type_cast(value)
          return unless value
          return value if ::BSON::Binary === value
          ::BSON::Binary.new(value)
        end
      end
    end
  end
end