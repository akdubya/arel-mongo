module Arel
  class Attribute
    def to_mongo(formatter=Mongo::NestedWhereCondition.new(relation))
      formatter.attribute self
    end

    def mongo_value(value)
      type_cast(value)
    end

    def mongo_format(object)
      object.to_mongo(Mongo::Attribute.new(self))
    end
  end

  class Expression < Attribute
    def initial_js; {} end
    def reduce_js; '' end
    def finalize_js; '' end

    def memo
      @memo ||= (@alias || attribute.name)
    end

    def to_mongo(*args)
      attribute.to_mongo(*args)
    end
  end

  class Count < Expression
    def initial_js; {memo => 0} end
    def reduce_js; "if (doc.#{attribute.name}) {memo.#{memo}++};" end
  end

  class Sum < Expression
    def initial_js; {memo => 0} end
    def reduce_js; "if (doc.#{attribute.name}) {memo.#{memo} += doc.#{attribute.name}};" end
  end

  class Maximum < Expression
    def initial_js; {memo => '-Infinity'} end
    def reduce_js; "if (doc.#{attribute.name} > memo.#{memo}) {memo.#{memo} = doc.#{attribute.name}};" end
    def finalize_js; "if (memo.#{memo} == '-Infinity') {memo.#{memo} = null};" end
  end

  class Minimum < Expression
    def initial_js; {memo => 'Infinity'} end
    def reduce_js; "if (doc.#{attribute.name} < memo.#{memo}) {memo.#{memo} = doc.#{attribute.name}};" end
    def finalize_js; "if (memo.#{memo} == 'Infinity') {memo.#{memo} = null};" end
  end

  class Average < Expression
    def memo_count; "#{memo}_count" end
    def memo_total; "#{memo}_total" end

    def initial_js; {memo_count => 0, memo_total => 0} end
    def reduce_js; "if (doc.#{attribute.name}) {memo.#{memo_count}++; memo.#{memo_total} += doc.#{attribute.name}};" end
    def finalize_js; "memo.#{memo} = memo.#{memo_total}/memo.#{memo_count}; delete memo.#{memo_total}; delete memo.#{memo_count};" end
  end

  class Value
    def to_mongo(formatter=Mongo::WhereCondition.new(relation))
      formatter.value value
    end

    def mongo_format(object)
      object.to_mongo(Mongo::Value.new(relation))
    end
  end

  class Ordering
    def to_mongo(*args)
      [attribute.to_mongo(*args), mongo_ordering]
    end
  end

  class Ascending < Ordering
    def mongo_ordering; :asc end
  end

  class Descending < Ordering
    def mongo_ordering; :desc end
  end
end