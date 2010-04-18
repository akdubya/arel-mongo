require 'spec_helper'

module Arel
  module Predicates
    describe ElemMatch do
      before do
        @relation = Arel::Collection.new(:users)
      end

      describe '#to_mongo' do
        before do
          @predicate1 = @relation['foo.bar'].eq(Arel::Value.new(1, @relation['foo'].to_element))
          @predicate2 = @relation['foo.baz'].eq(Arel::Value.new(1, @relation['foo'].to_element))
        end

        it 'manufactures a mongo elem match condition' do
          ElemMatch.new(@relation[:foo], @predicate1).to_mongo.should == {
            'foo' => {'$elemMatch' => {'bar' => 1}}
          }
        end

        it 'accepts multiple predicates' do
          ElemMatch.new(@relation[:foo], @predicate1, @predicate2).to_mongo.should == {
            'foo' => {'$elemMatch' => {'bar' => 1, 'baz' => 1}}
          }
        end
      end
    end
  end
end