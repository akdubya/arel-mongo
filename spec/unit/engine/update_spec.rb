require 'spec_helper'

module Arel
  describe 'Mongo::Engine#update' do
    before do
      @users = Collection.new(:users)
      @users.delete
    end

    it 'updates the relation' do
      @users.insert @users[:name] => "Nick"
      @users.update @users[:name] => "Bryan"
      @users.first[@users[:name]].should == "Bryan"
    end
  end
end