require 'spec_helper'

module Arel
  describe Union do
    before do
      @relation1 = Array.new([
        [1, 'duck' ],
        [2, 'duck' ],
        [3, 'goose']
      ], [[:id, Attributes::Integer], [:name, Attributes::String]])
      @relation2 = Array.new([
        [3, 'goose'  ],
        [4, 'batman' ],
      ], [[:id, Attributes::Integer], [:name, Attributes::String]])
    end

    describe '#call' do
      it 'performs a union over the two relations' do
        (@relation1 | @relation2).let do |relation|
          relation.call.should == [
            Row.new(relation, [1, 'duck']),
            Row.new(relation, [2, 'duck']),
            Row.new(relation, [3, 'goose']),
            Row.new(relation, [4, 'batman']),
          ]
        end
      end
    end
  end
end