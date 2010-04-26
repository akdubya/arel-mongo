require 'spec_helper'

module Arel
  describe Element do
    before do
      @relation = Collection.new(:users)
      @target = Embedded.new(:address,
        :attributes => [[:town, Attributes::String], [:zip, Attributes::Integer]])
      @element = Element.new(@relation, :address, :target => @target)
    end

    describe '#target' do
      it 'returns the target relation' do
        @element.target.should == @target
      end
    end

    describe '#attributes' do
      it 'returns the target relation\'s attributes bound to the element' do
        @element.attributes.should == @target.attributes.bind(@element)
      end
    end

    describe '#[]' do
      it 'finds the congruent attribute on the element' do
        @element[:town].should == Attributes::String.new(@target, :town).bind(@element)
      end
    end

    describe '#to_element' do
      it 'returns self when given no arguments' do
        @element.to_element.should equal(@element)
      end

      it 'returns self when given a target relation equivalent to the current target' do
        @element.to_element(@target).should equal(@element)
      end

      it 'manufactures a new element when given a new target relation' do
        new_target = Embedded.new(:foo)
        @element.to_element(new_target).should == Element.new(@relation, :address,
          :target => new_target, :ancestor => @element)
      end
    end
  end
end