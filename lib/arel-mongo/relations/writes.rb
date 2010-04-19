require 'active_support/core_ext/array/wrap'

module Arel
  class Compound
    def bind_to_record(object)
      return object.bind(self) unless Hash === object
      object.inject({}) do |bound, (key, value)|
        bound.merge(key.bind(self) => value.bind(self))
      end
    end
  end

  class Deletion < Compound
    def to_options
      @options
    end

    def initialize(relation, options={})
      @relation = relation
      @options  = options
    end
  end

  class Insert < Compound
    def to_records
      ::Array.wrap(record).map do |record|
        record.inject({}) do |memo, (key, value)|
          memo[key.to_mongo] = value.to_mongo; memo
        end
      end
    end

    def to_options
      @options
    end

    def initialize(relation, record, options={})
      @relation = relation
      @options  = options
      @record   = if ::Array === record
        record.map {|r| bind_to_record(r)}
      else
        bind_to_record(record)
      end
    end
  end

  class Update < Compound
    def to_modifier
      if Hash === assignments
        assignments.inject({}) do |memo, (key, value)|
          memo[key.to_mongo] = value.to_mongo; memo
        end
      else
        ::Array.wrap(assignments).inject({}) do |hsh, modifier|
          key, value = modifier.to_mongo.first
          if Hash === hsh[key] && modifier.mongo_operator
            hsh[key].merge!(value)
          else
            hsh[key] = value
          end
          hsh
        end
      end
    end

    def to_options
      @options
    end

    def initialize(relation, assignments, options={})
      @relation    = relation
      @options     = options
      @assignments = if ::Array === assignments
        assignments.map {|a| bind_to_record(a)}
      else
        bind_to_record(assignments)
      end
    end
  end
end