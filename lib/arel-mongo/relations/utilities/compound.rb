module Arel
  class Compound
    delegate :to_cursor, :to => :relation
  end
end