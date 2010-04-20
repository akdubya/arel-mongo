require 'spec_helper'

module Arel
  describe Relation do
    before do
      @relation = Arel::Collection.new(:users,
          :attributes => [[:id, Attributes::Integer], [:name, Attributes::String]])
      @attribute1 = @relation[:id]
      @attribute2 = @relation[:name]
    end

    describe '#[]' do
      describe 'when given a dot-notation string' do
        it 'manufactures a nested attribute' do
          @relation['name.foo'].should == @relation[:name]['foo']
        end
      end

      describe 'when given a non-existant attribute name' do
        it 'manufactures a generic attribute' do
          @relation[:foo].should == Attributes::Generic.new(@relation, :foo)
        end
      end
    end

    describe Relation::Writable do
      describe '#insert' do
        it 'takes an options hash' do
          lambda { @relation.insert({@attribute1 => 1}, :safe => true) }.should_not raise_error
        end
      end

      describe '#update' do
        it 'takes an options hash' do
          lambda { @relation.update({@attribute1 => 1}, :safe => true) }.should_not raise_error
        end
      end

      describe '#delete' do
        it 'takes an options hash' do
          lambda { @relation.delete(:safe => true) }.should_not raise_error
        end
      end
    end

    describe '#to_cursor' do
      it 'returns an Arel::Cursor' do
        @relation.to_cursor.should be_a_kind_of Cursor
      end
    end
  end
end