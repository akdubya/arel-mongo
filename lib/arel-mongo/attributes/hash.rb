module Arel
  module Attributes
    class Hash < Attribute
      def self.typecast(value)
        return value if value.kind_of?(::Hash)
        value.respond_to?(:to_hash) ? value.to_hash : nil
      end
    end
  end
end