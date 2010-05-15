module Arel
  module Modifiers
    class Modifier; end

    class Unary < Modifier
      attributes :operand
      deriving   :initialize

      def ==(other)
        self.class === other and
        @operand == other.operand
      end

      def bind(relation)
        self.class.new(operand.find_correlate_in(relation))
      end
    end

    class Binary < Modifier
      attributes :operand1, :operand2
      deriving :initialize

      def ==(other)
        self.class === other          and
        @operand1  ==  other.operand1 and
        @operand2  ==  other.operand2
      end

      def bind(relation)
        self.class.new(operand1.find_correlate_in(relation), operand2.find_correlate_in(relation))
      end
    end

    class Increment < Binary; end
    class Set < Binary; end
    class Unset < Unary; end
    class Push < Binary; end
    class PushAll < Binary; end
    class AddToSet < Binary; end
    class Pop < Binary; end
    class Pull < Binary; end
    class PullAll < Binary; end
  end
end