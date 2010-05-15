module Arel
  class Union
    def eval
      relation1.call | relation2.call
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