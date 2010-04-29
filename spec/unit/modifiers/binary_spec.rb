require 'spec_helper'

module Arel
  module Modifiers
    describe Binary do
      class ConcreteBinary < Binary
        def mongo_operator
          "$foo"
        end
      end

      before do
        @relation = Arel::Collection.new(:users, :attributes => [[:id, Arel::Attributes::Integer]])
      end

      describe '#to_mongo' do
        before do
          @value = Arel::Value.new(1, @relation)
          @value2 = Arel::Value.new('1', @relation)
        end

        it 'manufactures a mongo modifier' do
          ConcreteBinary.new(@relation[:id], @value).to_mongo.should == {
            '$foo' => {'id' => 1}
          }
        end

        it 'typecasts the operand' do
          ConcreteBinary.new(@relation[:id], @value2).to_mongo.should == {
            '$foo' => {'id' => 1}
          }
        end
      end
    end
  end
end