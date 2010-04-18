require 'spec_helper'

module Arel
  describe 'Mongo::Engine#read' do
    before do
      @users = Collection.new(:users)
      @users.delete
    end

    it 'reads from the relation' do
      @users.insert @users[:name] => "Bryan"

      @users.each do |row|
        row[@users[:name]].should == "Bryan"
      end
    end

    it 'implicitly handles groupings' do
      @users.insert @users[:name] => 'Bob', @users[:group] => 'foo'
      @users.insert @users[:name] => 'Jim', @users[:group] => 'foo'
      @users.insert @users[:name] => 'Sally', @users[:group] => 'bar'

      results = @users.group(@users[:group]).project(@users[:name].count).map {|row| row.data}
      results.should include({'group' => 'foo', 'name' => 2.0})
      results.should include({'group' => 'bar', 'name' => 1.0})
    end

    it 'implicitly handles distinct' do
      @users.insert @users[:name] => 'Bob', @users[:group] => 'foo'
      @users.insert @users[:name] => 'Jim', @users[:group] => 'foo'
      @users.insert @users[:name] => 'Sally', @users[:group] => 'bar'

      results = @users.project(@users[:group].distinct).map {|row| row.data}
      results.should == ['bar', 'foo']
    end
  end
end