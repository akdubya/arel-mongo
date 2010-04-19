module Arel
  module Sql
    module ObjectExtensions
      def to_mongo(formatter)
        formatter.scalar self
      end

      Object.send(:include, self)
    end
  end
end