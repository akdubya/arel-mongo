module Arel
  module Mongo
    class Engine
      attr_reader :db

      def initialize(db)
        @db = db
        @collections = {}
      end

      def collection(name)
        @collections[name] ||= db.collection(name)
      end

      module CRUD
        def create(relation)
          name    = relation.name
          records = relation.to_records
          options = relation.to_options
          collection(name).insert(records, options)
        end

        def read(relation)
          name        = relation.name
          selector    = relation.to_selector
          options     = relation.to_options
          groupings   = relation.groupings.map {|attr| attr.to_mongo}
          projections = relation.projections

          results = if groupings.any?
            group(name, groupings, selector, projections)
          elsif distinct_key = projections.detect {|proj| Arel::Distinct === proj}
            distinct(distinct_key, name, selector)
          else
            cursor = collection(name).find(selector, options)
            cursor = [cursor.count] if relation.count?
            cursor
          end

          Cursor.new(results, relation.attributes, relation)
        end

        def update(relation)
          name     = relation.name
          selector = relation.to_selector
          modifier = relation.to_modifier
          options  = relation.to_options
          collection(name).update(selector, modifier, options)
        end

        def delete(relation)
          name     = relation.name
          selector = relation.to_selector
          options  = relation.to_options
          collection(name).remove(selector, options)
        end
      end
      include CRUD

      def inspect
        "<#{self.class.name} #{db.name}>"
      end

      private

      def group(name, groupings, selector, projections)
        initial   = {}
        reduce    = 'function(doc, memo) {'
        finalize  = 'function(memo) {'

        projections.each do |proj|
          if proj.aggregation?
            initial.merge!(proj.initial_js)
            reduce << proj.reduce_js
            finalize << proj.finalize_js
          end
        end

        reduce << '}'
        finalize << '}'

        collection(name).group(groupings, selector, initial, reduce, finalize)
      end

      def distinct(key, name, selector)
        collection(name).distinct(key.to_mongo, selector)
      end
    end
  end
end