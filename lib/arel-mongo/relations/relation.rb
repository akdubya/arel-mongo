module Arel
  module Relation
    def [](index)
      if String === index
        names = index.split('.')
        return build_element(names) if names.length > 1
      end
      super
    end

    module Writable
      def insert(record, options={})
        session.create Insert.new(self, record, options)
      end

      def update(assignments, options={})
        session.update Update.new(self, assignments, options)
      end

      def delete(options={})
        session.delete Deletion.new(self, options)
      end
    end
    include Writable

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

    def to_options
      opts = {
        :skip  => skipped,
        :limit => taken,
        :sort  => orders.map {|dir| dir.to_mongo}
      }
      opts[:fields] = projections.map {|proj| proj.to_mongo} if projections.any?
      opts
    end

    def build_element(names)
      first = self[names.shift]
      names.inject(first) do |element, name|
        element = element[name]
      end
    end
  end
end