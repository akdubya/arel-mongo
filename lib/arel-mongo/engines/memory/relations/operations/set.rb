module Arel
  class Union
    def eval
      seen = []
      relation1.each {|row| seen << row.bind(self)}
      relation2.each {|row| row = row.bind(self); seen << row unless seen.include?(row)}
      seen
    end
  end

  class Intersection
    def eval
      relation1.call & relation2.call
    end
  end

  class Difference
    def eval
      relation1.call - relation2.call
    end
  end
end