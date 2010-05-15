require 'spec_helper'

module Arel
  describe Array do
    before do
      @relation = Array.new([{'id' => 1, 'name' => 'bob'}],
        [[:id, Attributes::Integer], [:name, Attributes::String]],
        Collection.new(:foo))
      @attribute1 = @relation[:id]
      @attribute2 = @relation[:name]
    end

    describe 'when initialized with a Collection' do
      it 'instantiates rows as documents' do
        @relation.first.should be_a Document
        @relation.first[@relation[:name]].should == 'bob'
      end
    end
  end
end