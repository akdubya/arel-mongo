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
  end
end