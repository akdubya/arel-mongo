require 'spec_helper'

module Arel
  describe Attribute do
    before do
      @relation = Arel::Collection.new(:users)
    end

    describe Attribute::Predications do
      before do
        @attribute = Attribute.new(@relation, :name)
      end

      describe '#ne' do
        it 'manufactures an inequality predicate' do
          @attribute.ne('name').should == Predicates::Inequality.new(@attribute, 'name')
        end
      end

      describe '#nin' do
        it 'manufactures a not-in predicate' do
          @attribute.nin(['name']).should == Predicates::NotIn.new(@attribute, ['name'])
        end
      end

      describe '#mod' do
        it 'manufactures a modulo predicate' do
          @attribute.mod([10, 1]).should == Predicates::Modulo.new(@attribute, [10, 1])
        end
      end

      describe '#all' do
        it 'manufactures an all predicate' do
          @attribute.all(['name']).should == Predicates::All.new(@attribute, ['name'])
        end
      end

      describe '#size' do
        it 'manufactures a size predicate' do
          @attribute.size(1).should == Predicates::Size.new(@attribute, 1)
        end
      end

      describe '#exists' do
        it 'manufactures an exists predicate' do
          @attribute.exists(true).should == Predicates::Exists.new(@attribute, true)
        end
      end

      describe '#elem' do
        it 'manufactures an element match predicate' do
          pred1 = @attribute['foo'].eq(5)
          pred2 = @attribute['bar'].eq('hey')
          @attribute.elem(pred1, pred2).should == Predicates::ElemMatch.new(@attribute, pred1, pred2)
        end
      end
    end

    describe Attribute::Modifications do
      before do
        @attribute = Attribute.new(@relation, :name)
      end

      describe '#inc' do
        it 'manufactures an increment modifier' do
          @attribute.inc(1).should == Modifiers::Increment.new(@attribute, 1)
        end
      end

      describe '#set' do
        it 'manufactures a set modifier' do
          @attribute.set('name').should == Modifiers::Set.new(@attribute, 'name')
        end
      end

      describe '#unset' do
        it 'manufactures an unset modifier' do
          @attribute.unset.should == Modifiers::Unset.new(@attribute)
        end
      end

      describe '#push' do
        it 'manufactures a push modifier when given a single argument' do
          @attribute.push('hello').should == Modifiers::Push.new(@attribute, 'hello')
        end

        it 'manufactures a push-all modifier when given multiple arguments' do
          @attribute.push('hello', 'goodbye').should == Modifiers::PushAll.new(@attribute, ['hello', 'goodbye'])
        end
      end

      describe '#add' do
        it 'manufactures an add-to-set modifier' do
          @attribute.add('name').should == Modifiers::AddToSet.new(@attribute, 'name')
        end
      end

      describe '#pop' do
        it 'manufactures a pop modifier' do
          @attribute.pop(1).should == Modifiers::Pop.new(@attribute, 1)
        end
      end

      describe '#pull' do
        it 'manufactures a pull modifier when given a single argument' do
          @attribute.pull('hello').should == Modifiers::Pull.new(@attribute, 'hello')
        end

        it 'manufactures a pull-all modifier when given multiple arguments' do
          @attribute.pull('hello', 'goodbye').should == Modifiers::PullAll.new(@attribute, ['hello', 'goodbye'])
        end
      end
    end

    describe '#distinct' do
      before do
        @attribute = Attribute.new(@relation, :name)
      end

      it 'manufactures a distinct expression' do
        @attribute.distinct.should == Distinct.new(@attribute)
      end
    end

    describe '#to_element' do
      before do
        @attribute = Attribute.new(@relation, :name)
      end

      it 'manufactures an element from an attribute' do
        @attribute.to_element.should == Element.new(@relation, :name)
      end
    end

    describe '#[]' do
      before do
        @attribute = Attribute.new(@relation, :name)
      end

      it 'manufactures an element attribute' do
        @attribute[:foo].should == Attribute.new(@relation[:name].to_element, :foo)
      end
    end

    describe '#nested?' do
      before do
        @attribute = Attribute.new(@relation, :name)
      end

      it 'returns true if the attribute is nested' do
        @attribute[:foo].nested?.should be_true
      end

      it 'returns false if the attribute is not nested' do
        @attribute.nested?.should be_false
      end
    end

    describe '#to_mongo' do
      before do
        @attribute = Attribute.new(@relation, :name)
      end

      it 'returns the name of a regular attribute' do
        @attribute.to_mongo.should == 'name'
      end

      it 'returns dot notation for a nested attribute' do
        @attribute[:foo].to_mongo.should == 'name.foo'
      end

      it 'accepts a nested argument' do
        @attribute[:foo].to_mongo(false).should == 'foo'
      end
    end
  end
end