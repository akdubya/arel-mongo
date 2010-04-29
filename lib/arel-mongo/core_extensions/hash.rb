module Arel
  module Mongo
    module HashExtensions
      def to_mongo(formatter)
        formatter.embedded self
      end

      ::Hash.send(:include, self)
    end
  end
end