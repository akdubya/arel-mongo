module Arel
  class Collection
    include Mongo::Relation, Recursion::BaseCase

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
  end
end