module Arel
  class Document
    attributes :relation, :data
    deriving :==, :initialize

    def [](attribute)
      data[attribute.name.to_s]
    end

    def bind(relation)
      Document.new(relation, data)
    end
  end
end