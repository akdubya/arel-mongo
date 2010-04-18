module Docodo
  class Attribute
    class Symbol < Object
      def self.typecast(value)
        return value if value.nil? || value.kind_of?(::Symbol)
        value.to_sym
      end
    end
  end
end