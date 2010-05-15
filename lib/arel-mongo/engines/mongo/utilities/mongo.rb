module Mongo
  class Cursor
    def next
      doc = next_document
      raise StopIteration unless doc
      doc
    end

    def to_enum
      self
    end
  end
end