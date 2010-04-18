require 'active_support/core_ext/object/duplicable'

module Arel
  module Attributes
    class Object < Attribute
      def self.primitive
        ::Object.const_get(name.demodulize.to_sym)
      end

      def self.typecast(value); value end

      def self.read(value); value end

      def self.write(value); value end

      def self.copy(value)
        value.duplicable? ? value.dup : value
      end

      def type_cast(value)
        self.typecast(value)
      end
    end
  end
end