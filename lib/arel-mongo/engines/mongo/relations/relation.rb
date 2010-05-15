module Arel
  module Relation
    def length
      project(self[:_id].count)
    end

    def count?
      projections.any? {|proj| Arel::Count === proj && proj.attribute.named?(:_id)}
    end

    def to_selector
      wheres.inject({}) do |hsh, predicate|
        key, value = predicate.to_mongo.first
        if Hash === hsh[key] && predicate.mongo_operator
          hsh[key].merge!(value)
        else
          hsh[key] = value
        end
        hsh
      end
    end

    def to_enum
      call.to_enum
    end

    def to_options
      opts = {
        :skip  => skipped,
        :limit => taken,
        :sort  => orders.map {|dir| dir.to_mongo}
      }
      opts[:fields] = projections.map {|proj| proj.to_mongo} if projections.any?
      opts
    end
  end

  module Mongo
    module Relation
      include Arel::Relation

      def [](index)
        super || case index
        when String
          names = index.split('.')
          return build_element(names) if names.length > 1
          Attributes::Generic.new(self, index)
        when Symbol
          Attributes::Generic.new(self, index)
        end
      end

      def row_klass
        Document
      end

      private

      def build_element(names)
        first = self[names.shift]
        names.inject(first) do |element, name|
          element = element[name]
        end
      end
    end
  end
end