module Arel
  class Element < Attribute
    attr_reader :target, :attributes

    def [](index)
      attributes[index] || Attributes::Generic.new(self, index)
    end

    def to_element(new_target=nil)
      if new_target && new_target != target
        Element.new(relation, name, {:alias => @alias, :ancestor => self, :target => new_target})
      else
        self
      end
    end

    def as(aliaz = nil)
      Element.new(relation, name, :alias => aliaz, :ancestor => self, :target => target)
    end

    def bind(new_relation)
      relation == new_relation ? self : Element.new(new_relation, name, :alias => @alias, :ancestor => self, :target => target)
    end

    def mongo_format(object)
      object.to_mongo(Mongo::Element.new(self))
    end

    def initialize(relation, name, options={})
      super
      @target     = options.fetch(:target, Embedded.new(name))
      @attributes = target.attributes.bind(self)
    end
  end
end