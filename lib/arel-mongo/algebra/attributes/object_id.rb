module Arel
  module Attributes
    module BSON
      class ObjectID < Attribute
        def type_cast(value)
          return unless value
          return value if ::BSON::ObjectID === value
          ::BSON::ObjectID.from_string(value)
        end
      end
    end
  end
end