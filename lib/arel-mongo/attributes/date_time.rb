require 'date'

module Arel
  module Attributes
    class DateTime < Object
      def self.typecast(value)
        return value if value.kind_of?(::DateTime)
        return nil if value.blank?
        ::DateTime.parse(value.to_s)
      end

      def self.read(value)
        typecast(value)
      end

      def self.write(value)
        return nil unless value
        value.to_time
      end
    end
  end
end