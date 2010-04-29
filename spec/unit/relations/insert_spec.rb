require 'spec_helper'

module Arel
  describe Insert do
    before do
      @relation = Collection.new(:users,
          :attributes => [[:id, Attributes::Integer], [:name, Attributes::String], [:address, Attributes::Hash]])
    end

    describe '#to_records' do
      it 'manufactures a mongo records array' do
        @insertion = Insert.new(@relation, @relation[:id] => "1", @relation[:name] => "nick")
        @insertion.to_records.should == [{"id"=>1, "name"=>"nick"}]
      end

      it 'manufactures a mongo records array when given multiple rows' do
        @insertion = Insert.new(@relation, [{@relation[:name] => "nick"}, {@relation[:name] => "bryan"}])
        @insertion.to_records.should == [{"name"=>"nick"}, {"name"=>"bryan"}]
      end

      it 'binds inserted hashes as plain values' do
        @insertion = Insert.new(@relation, @relation[:id] => "1", @relation[:address] => {'town' => 'babylon'})
        @insertion.to_records.should == [{"id"=>1, "address"=>{"town"=>"babylon"}}]
      end
    end

    describe '#to_options' do
      it 'manufactures a mongo options hash' do
        @insertion = Insert.new(@relation, {@relation[:id] => "1", @relation[:name] => "nick"}, :safe => true)
        @insertion.to_options.should == {:safe => true}
      end
    end
  end
end