require 'spec_helper'

module Arel
  describe Union do
    before do
      @relation1 = Collection.new(:users1)
      @relation2 = Collection.new(:users2)
    end
  end
end