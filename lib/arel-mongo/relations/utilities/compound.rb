module Arel
  class Compound
    delegate :to_selector, :to_options, :to => :relation
  end
end