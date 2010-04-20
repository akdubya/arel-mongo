require 'spec_helper'

module Arel
  module Predicates
    describe In do
      before do
        @relation = Arel::Collection.new(:users,
          :attributes => [[:id, Arel::Attributes::Integer]])
        @attribute = @relation[:id]
      end

      describe '#to_mongo' do
        describe 'when relating to an array' do
          describe 'when the array\'s elements are the same type as the attribute' do
            before do
              @array = [1,2,3]
            end

            it 'manufactures a mongo $in condition' do
              In.new(@attribute, @array).to_mongo.should ==
                {'id' => {'$in' => [1,2,3]}}
            end
          end
          
          describe 'when the array\'s elements are not same type as the attribute' do
            before do
              @array = ['1', 2, 3]
            end
            
            it 'formats values in the array as the type of the attribute' do
              In.new(@attribute, @array).to_mongo.should ==
                {'id' => {'$in' => [1,2,3]}}
            end
          end
        end
      end
    end
  end
end