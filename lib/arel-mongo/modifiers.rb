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

      def mongo_operator; end

      def to_mongo
        {mongo_operator => {operand1.to_mongo => operand1.mongo_format(operand2)}}
      end

      def ==(other)
        self.class === other          and
        @operand1  ==  other.operand1 and
        @operand2  ==  other.operand2
      end

      def bind(relation)
        self.class.new(operand1.find_correlate_in(relation), operand2.find_correlate_in(relation))
      end
    end

    class Increment < Binary
      def mongo_operator; '$inc' end
    end

    class Set < Binary
      def mongo_operator; '$set' end
    end

    class Unset < Unary
      def mongo_operator; '$unset' end

      def to_mongo
        {mongo_operator => {operand.to_mongo => 1}}
      end
    end

    class Push < Binary
      def mongo_operator; '$push' end
    end

    class PushAll < Binary
      def mongo_operator; '$pushAll' end
    end

    class AddToSet < Binary
      def mongo_operator; '$addToSet' end
    end

    class Pop < Binary
      def mongo_operator; '$pop' end
    end

    class Pull < Binary
      def mongo_operator; '$pull' end
    end

    class PullAll < Binary
      def mongo_operator; '$pullAll' end
    end
  end
end