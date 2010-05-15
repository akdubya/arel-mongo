module Arel
  class Array
    def initialize(array, attribute_names_and_types, original_relation=self)
      @array, @attribute_names_and_types, @original_relation = array, attribute_names_and_types, original_relation
    end

    def eval
      @array.collect {|r| @original_relation.load(self, r)}
    end
  end
end