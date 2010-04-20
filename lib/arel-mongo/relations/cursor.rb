module Arel
  class Cursor
    include Relation

    attributes :cursor, :attribute_names_and_types
    include Recursion::BaseCase
    deriving :==, :initialize

    def initialize(cursor, attribute_names_and_types)
      @cursor, @attribute_names_and_types = cursor, attribute_names_and_types
      @cursor = @cursor.to_enum if Array === @cursor
    end

    def engine
      @engine ||= Memory::Engine.new
    end

    def attributes
      @attributes ||= begin
        attrs = @attribute_names_and_types.collect do |attribute, type|
          attribute = type.new(self, attribute) if Symbol === attribute
          attribute
        end
        Header.new(attrs)
      end
    end

    def to_cursor
      self
    end

    def next
      @cursor.next
    end

    def each
      @cursor.each {|doc| yield Document.new(self, doc)}
    end

    def first
      return unless doc = @cursor.first
      Document.new(self, doc)
    end

    def eval
      self
    end
  end
end