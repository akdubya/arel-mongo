module Arel
  class Collection
    include Relation, Recursion::BaseCase

    cattr_accessor :engine, :collections
    attr_reader :name, :engine, :options, :attributes

    def initialize(name, options={})
      @name       = name.to_s
      @engine     = options.fetch(:engine, Collection.engine)
      @attributes = Header.new((options[:attributes] || []).map do |attr, type|
        attr = type.new(self, attr) if Symbol === attr
        attr
      end)
    end

    def [](index)
      super || case index
      when String
        names = index.split('.')
        return build_element(names) if names.length > 1
        Attributes::Generic.new(self, index)
      when Symbol
        Attributes::Generic.new(self, index)
      end
    end

    private

    def build_element(names)
      first = self[names.shift]
      names.inject(first) do |element, name|
        element = element[name]
      end
    end
  end
end