module Arel
  class SetOperation
    include Relation

    attributes :relation1, :relation2
    deriving :==, :initialize
    delegate :name, :load, :to => :relation1

    def hash
      @hash ||= relation1.hash ^ relation2.hash
    end

    def eql?(other)
      self == other
    end

    def attributes
      @attributes ||= relation1.attributes
    end

    def engine
      @engine ||= Memory::Engine.new
    end
  end

  class Union < SetOperation; end
  class Intersection < SetOperation; end
  class Difference < SetOperation; end
end