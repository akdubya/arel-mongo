module Arel
  class Array
    def initialize(array, attribute_names_and_types, row_klass=Row)
      @array, @attribute_names_and_types, @row_klass = array, attribute_names_and_types, row_klass
    end

    def eval
      @array.collect { |r| row_klass.new(self, r) }
    end
  end
end