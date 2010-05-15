module Arel
  module Attributes
    class Hash < Attribute
      def type_cast(value)
        return value if value.kind_of?(::Hash)
        value.respond_to?(:to_hash) ? value.to_hash : nil
      end
    end
  end
end