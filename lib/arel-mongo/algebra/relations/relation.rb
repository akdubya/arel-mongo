module Arel
  module Relation
    def insert(record, options={})
      session.create Insert.new(self, record, options)
    end

    def update(assignments, options={})
      session.update Update.new(self, assignments, options)
    end

    def delete(options={})
      session.delete Deletion.new(self, options)
    end

    def row_klass
      @row_klass ||= Row
    end

    def |(other)
      Union.new(self, other)
    end

    def -(other)
      Difference.new(self, other)
    end

    def &(other)
      Intersection.new(self, other)
    end
  end
end