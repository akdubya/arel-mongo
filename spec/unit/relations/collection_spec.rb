require 'spec_helper'

module Arel
  describe Collection do
    before do
      @relation = Collection.new(:users,
          :attributes => [[:id, Attributes::Integer], [:address, Attributes::Hash]])
      @attribute1 = @relation[:id]
      @attribute2 = @relation[:address]
    end

    describe '#[]' do
      describe 'when given a dot-notation string' do
        it 'manufactures a nested attribute' do
          @relation['address.foo'].should == @relation[:address]['foo']
        end
      end

      describe 'when given a non-existant attribute name' do
        it 'manufactures a generic attribute' do
          @relation[:foo].should == Attributes::Generic.new(@relation, :foo)
        end
      end
    end
  end
end