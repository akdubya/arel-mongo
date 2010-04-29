module Arel
  module HashExtensions
    def bind(relation)
      inject({}) do |bound, (key, value)|
        value = Hash === value ? Arel::Value.new(value, relation) : value.bind(relation)
        bound.merge(key.bind(relation) => value)
      end
    end
  end
end