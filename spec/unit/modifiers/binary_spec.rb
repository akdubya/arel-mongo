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
        @relation = Arel::Collection.new(:users)
      end

      describe '#to_mongo' do
        before do
          @value = Arel::Value.new(1, @relation)
        end

        it 'manufactures a mongo modifier' do
          ConcreteBinary.new(@relation[:id], @value).to_mongo.should == {
            '$foo' => {'id' => 1}
          }
        end
      end
    end
  end
end