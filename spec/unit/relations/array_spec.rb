require 'spec_helper'

module Arel
  describe Array do
    before do
      @relation = Array.new([{'id' => 1, 'name' => 'bob'}],
        [[:id, Attributes::Integer], [:name, Attributes::String]],
        Document)
      @attribute1 = @relation[:id]
      @attribute2 = @relation[:name]
    end

    describe 'when initialized with a Document row class' do
      it 'instantiates rows as documents' do
        @relation.first.should be_a_kind_of Document
        @relation.first[@relation[:name]].should == 'bob'
      end
    end
  end
end