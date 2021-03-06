module Arel
  module Mongo
    class Formatter
      attr_reader :environment
      delegate :engine, :to => :environment

      def initialize(environment)
        @environment = environment
      end
    end

    class WhereCondition < Formatter
      def attribute(attribute)
        attribute.name.to_s
      end

      def value(value)
        value.to_mongo(self)
      end

      def scalar(value)
        value
      end
    end

    class NestedWhereCondition < Formatter
      def attribute(attribute)
        attribute.nested_name
      end
    end

    class Attribute < WhereCondition
      def scalar(scalar)
        environment.mongo_value(scalar)
      end

      def embedded(hash)
        hash
      end
    end

    class Element < Formatter
      def embedded(hash)
        hash.inject({}) do |h, (attr, value)|
          h.merge!(attr.to_mongo => attr.mongo_format(value))
        end
      end

      def value(value)
        value
      end
    end

    class Value < WhereCondition
    end
  end
end