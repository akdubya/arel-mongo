module Arel
  class Compound
    delegate :load, :to => :relation
  end
end