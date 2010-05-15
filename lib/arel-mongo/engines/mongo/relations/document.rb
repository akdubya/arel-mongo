module Arel
  class Document
    include Enumerable

    attributes :relation, :data
    deriving :==, :initialize

    def [](attribute)
      attribute.type_cast(data[(attribute.alias || attribute.name).to_s])
    end

    def bind(relation)
      Document.new(relation, data)
    end

    def each
      data.each_pair do |key, value|
        attr = relation[key]
        yield(attr, attr.type_cast(value))
      end
    end
  end
end