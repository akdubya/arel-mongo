require 'spec_helper'

module Arel
  describe 'Mongo::Engine#create' do
    before do
      @users = Collection.new(:users)
      @users.delete
    end

    it 'inserts into the relation' do
      @users.insert @users[:name] => "Bryan"
      @users.first[@users[:name]].should == "Bryan"
    end
  end
end