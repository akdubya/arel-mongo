require 'spec_helper'

module Arel
  describe Relation do
    before do
      @relation = Arel::Collection.new(:users,
          :attributes => [[:id, Attributes::Integer], [:name, Attributes::String]])
      @attribute1 = @relation[:id]
      @attribute2 = @relation[:name]
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
  end
end