require 'spec_helper'

module Arel
  describe 'Mongo::Engine#delete' do
    before do
      @users = Collection.new(:users)
      @users.delete
    end

    it 'deletes from the relation' do
      @users.insert @users[:name] => "Bryan"
      @users.delete
      @users.first.should == nil
    end
  end
end