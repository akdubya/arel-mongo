module Arel
  class Embedded < Collection
    def initialize(name, options={})
      @name       = name.to_s
      @attributes = Header.new((options[:attributes] || []).map do |attr, type|
        attr = type.new(self, attr) if Symbol === attr
        attr
      end)
    end

    def engine
      @engine ||= Memory::Engine.new
    end
  end
end