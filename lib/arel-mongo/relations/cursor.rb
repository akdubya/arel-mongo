require 'hamster/list'

module Arel
  class Cursor
    include Relation

    attributes :cursor, :attribute_names_and_types
    include Recursion::BaseCase
    deriving :==, :initialize

    def initialize(cursor, attribute_names_and_types)
      @cursor, @attribute_names_and_types = cursor.to_enum, attribute_names_and_types
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

    module Enumerable
      def to_enum
        self
      end

      def next
        coerce_row(@cursor.next)
      end

      def each
        to_list.each {|doc| yield doc}
        self
      end

      def first
        to_list.first
      end

      def to_list
        @list ||= build_list
      end
    end
    include Enumerable

    def coerce_row(row)
      Document.new(self, row)
    end

    def eval
      self
    end

    private

    def build_list
      Hamster::Stream.new do
        begin
          Hamster::Sequence.new(coerce_row(@cursor.next), build_list)
        rescue StopIteration
          Hamster::EmptyList
        end
      end
    end
  end
end