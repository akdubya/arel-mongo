module Arel
  class Document
    attributes :relation, :data
    deriving :==, :initialize

    def [](attribute)
      data[attribute.name.to_s]
    end

    def slice(*attributes)
      Document.new(relation, attributes.inject({}) do |hsh, attribute|
        hsh[attribute.name.to_s] = data[attribute.name.to_s]
        hsh
      end)
    end

    def bind(relation)
      Document.new(relation, data)
    end

    def combine(other, relation)
      Document.new(relation, data.merge(other.data))
    end
  end
end