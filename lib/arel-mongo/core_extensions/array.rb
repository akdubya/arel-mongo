module Arel
  module Mongo
    module ArrayExtensions
      def to_mongo(formatter=nil)
        map {|e| e.to_mongo(formatter)}
      end

      ::Array.send(:include, self)
    end
  end
end