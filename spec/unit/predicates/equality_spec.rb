require 'spec_helper'

module Arel
  module Predicates
    describe Equality do
      before do
        @relation = Arel::Collection.new(:users)
      end

      describe '#to_mongo' do
        before do
          @value = Arel::Value.new(1, @relation)
        end

        it 'manufactures a mongo equality condition' do
          Equality.new(@relation[:id], @value).to_mongo.should == {'id' => 1}
        end
      end
    end
  end
end