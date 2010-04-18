module Arel
  module Predicates
    class Binary < Predicate
      def mongo_operator; end

      def to_mongo(*args)
        {operand1.to_mongo(*args) => {mongo_operator => operand2.to_mongo(*args)}}
      end
    end

    class Equality < Binary
      def to_mongo(*args)
        {operand1.to_mongo(*args) => operand2.to_mongo(*args)}
      end
    end

    class Match < Binary
      def to_mongo(*args)
        {operand1.to_mongo(*args) => operand2.to_mongo(*args)}
      end
    end

    class Inequality < Binary
      def mongo_operator; '$ne' end
    end

    class Not < Binary
      def mongo_operator; '$not' end
    end

    class GreaterThanOrEqualTo < Binary
      def mongo_operator; '$gte' end
    end

    class GreaterThan < Binary
      def mongo_operator; '$gt' end
    end

    class LessThanOrEqualTo < Binary
      def mongo_operator; '$lte' end
    end

    class LessThan < Binary
      def mongo_operator; '$lt' end
    end

    class In < Binary
      def mongo_operator; '$in' end
    end

    class NotIn < Binary
      def mongo_operator; '$nin' end
    end

    class Modulo < Binary
      def mongo_operator; '$mod' end
    end

    class All < Binary
      def mongo_operator; '$all' end
    end

    class Size < Binary
      def mongo_operator; '$size' end
    end

    class Exists < Binary
      def mongo_operator; '$exists' end
    end

    class Type < Binary
      def mongo_operator; '$type' end
    end

    class ElemMatch
      attributes :operand, :predicates

      def mongo_operator; '$elemMatch' end

      def bind(relation)
        element = operand.find_correlate_in(relation).to_element
        self.class.new(element, *predicates.map {|p| p.bind(element)})
      end

      def to_mongo
        {operand.to_mongo => {mongo_operator => mongofy}}
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

      def mongofy
        predicates.inject({}) do |hsh, predicate|
          key, value = predicate.to_mongo(false).first
          if Hash === hsh[key] && predicate.mongo_operator
            hsh[key].merge!(value)
          else
            hsh[key] = value
          end
          hsh
        end
      end
    end
  end
end