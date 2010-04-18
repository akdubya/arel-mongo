require 'spec_helper'

module Arel
  module Modifiers
    describe Unset do
      before do
        @users = Arel::Collection.new(:users)
      end

      it 'has a mongo operator' do
        Unset.new(@users[:foo]).mongo_operator.should == '$unset'
      end

      describe '#to_mongo' do
        it 'manufactures a mongo unset modifier' do
          Unset.new(@users[:foo]).to_mongo.should == {
            '$unset' => {'foo' => 1}
          }
        end
      end
    end
  end
end