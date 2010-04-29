require 'spec_helper'

module Arel
  module Predicates
    describe Equality do
      before do
        @relation = Arel::Collection.new(:users)
      end

      describe '#to_mongo' do
        it 'manufactures a mongo equality condition' do
          Equality.new(@relation[:id], 1).to_mongo.should == {'id' => 1}
        end
      end
    end
  end
end