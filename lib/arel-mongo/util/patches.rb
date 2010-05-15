module Arel
  module HashExtensions
    def bind(relation)
      inject({}) do |bound, (key, value)|
        value = Hash === value ? Arel::Value.new(value, relation) : value.bind(relation)
        bound.merge!(key.bind(relation) => value)
      end
    end
  end

  module Relation
    def row_klass
      @row_klass ||= Row
    end
  end

  class Array
    def initialize(array, attribute_names_and_types, row_klass=Row)
      @array, @attribute_names_and_types, @row_klass = array, attribute_names_and_types, row_klass
    end

    def eval
      @array.collect { |r| row_klass.new(self, r) }
    end
  end
end