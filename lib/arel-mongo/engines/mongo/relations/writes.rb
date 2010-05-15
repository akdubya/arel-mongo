require 'active_support/core_ext/array/wrap'

module Arel
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
          memo[key.to_mongo] = key.mongo_format(value); memo
        end
      end
    end

    def to_options
      @options
    end

    def initialize(relation, record, options={})
      @relation = relation
      @record = ::Array === record ?
        record.map {|a| a.bind(relation)}
        : record.bind(relation)
      @options = options
    end
  end

  class Update < Compound
    def to_modifier
      if Hash === assignments
        assignments.inject({}) do |memo, (key, value)|
          memo[key.to_mongo] = key.mongo_format(value); memo
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
      @relation = relation
      @assignments = ::Array === assignments ?
        assignments.map {|a| a.bind(relation)}
        : assignments.bind(relation)
      @options = options
    end
  end
end