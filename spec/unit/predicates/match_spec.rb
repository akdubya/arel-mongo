require 'spec_helper'

module Arel
  module Predicates
    describe Match do
      before do
        @relation = Arel::Collection.new(:users)
      end

      describe '#to_mongo' do
        before do
          @value = Arel::Value.new(/foo/, @relation)
        end

        it 'manufactures a mongo match condition' do
          Match.new(@relation[:name], @value).to_mongo.should == {'name' => /foo/}
        end
      end
    end
  end
end