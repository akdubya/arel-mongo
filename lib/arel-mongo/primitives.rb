module Arel
  class Attribute
    module Predications
      def ne(other)
        Predicates::Inequality.new(self, other)
      end

      def nin(other)
        Predicates::NotIn.new(self, other)
      end

      def mod(array)
        Predicates::Modulo.new(self, array)
      end

      def all(array)
        Predicates::All.new(self, array)
      end

      def size(num)
        Predicates::Size.new(self, num)
      end

      def exists(bool)
        Predicates::Exists.new(self, bool)
      end

      def elem(*predicates)
        Predicates::ElemMatch.new(self, *predicates)
      end
    end
    include Predications

    module Modifications
      def inc(num)
        Modifiers::Increment.new(self, num)
      end

      def set(value)
        Modifiers::Set.new(self, value)
      end

      def unset
        Modifiers::Unset.new(self)
      end

      def push(*values)
        values.length > 1 ? Modifiers::PushAll.new(self, values) : Modifiers::Push.new(self, values.first)
      end

      def add(*values)
        Modifiers::AddToSet.new(self, *values)
      end

      def pop(num)
        Modifiers::Pop.new(self, num)
      end

      def pull(*values)
        values.length > 1 ? Modifiers::PullAll.new(self, values) : Modifiers::Pull.new(self, values.first)
      end
    end
    include Modifications

    def distinct
      Distinct.new(self)
    end

    def [](index)
      to_element[index]
    end

    def to_element(target=nil)
      opts = {:alias => @alias, :ancestor => self}
      opts[:target] = target if target
      Element.new(relation, name, opts)
    end

    def nested?
      Element === relation
    end

    def nested_name
      nested? ? "#{relation.nested_name}.#{name}" : name.to_s
    end

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

  class Element < Attribute
    attr_reader :target, :attributes

    def [](index)
      attributes[index] || Attributes::Generic.new(self, index)
    end

    def to_element(new_target=nil)
      if new_target && new_target != target
        Element.new(relation, name, {:alias => @alias, :ancestor => self, :target => new_target})
      else
        self
      end
    end

    def initialize(relation, name, options={})
      super
      @target     = options.fetch(:target, Embedded.new(name))
      @attributes = target.attributes.bind(self)
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