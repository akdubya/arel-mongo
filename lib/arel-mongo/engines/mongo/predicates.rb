module Arel
  module Predicates
    class Binary < Predicate
      def mongo_operator; end

      def to_mongo(*args)
        {operand1.to_mongo(*args) => {mongo_operator => operand1.mongo_format(operand2)}}
      end
    end

    class Equality < Binary
      def to_mongo(*args)
        {operand1.to_mongo(*args) => operand1.mongo_format(operand2)}
      end
    end

    class Match < Binary
      def to_mongo(*args)
        {operand1.to_mongo(*args) => operand1.mongo_format(operand2)}
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
      def mongo_operator; '$elemMatch' end

      def to_mongo
        {operand.to_mongo => {mongo_operator => mongofy}}
      end

      def mongofy
        formatter = Mongo::WhereCondition.new(operand.relation)
        predicates.inject({}) do |hsh, predicate|
          key, value = predicate.to_mongo(formatter).first
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