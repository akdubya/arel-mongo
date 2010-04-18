require 'date'

module Arel
  module Attributes
    class Date < Object
      def self.typecast(value)
        return value if value.kind_of?(::Date)
        return nil if value.blank?
        ::Date.parse(value.to_s)
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