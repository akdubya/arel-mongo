module Docodo
  class Attribute
    class Regexp < Object
      def self.typecast(value)
        return value if value.nil? || value.kind_of?(::Regexp)
        ::Regexp.new(value)
      end
    end
  end
end