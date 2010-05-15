module Arel
  module Predicates
    class Inequality < Binary; end
    class NotIn      < Binary; end
    class Modulo     < Binary; end
    class All        < Binary; end
    class Size       < Binary; end
    class Exists     < Binary; end
    class Type       < Binary; end

    class ElemMatch
      attributes :operand, :predicates

      def bind(relation)
        element = operand.find_correlate_in(relation).to_element
        self.class.new(element, *predicates.map {|p| p.bind(element)})
      end

      def ==(other)
        self.class  === other         and
        @operand    ==  other.operand and
        @predicates ==  other.predicates
      end

      def initialize(operand, *predicates)
        @operand    = operand
        @predicates = predicates
      end
    end
  end
end