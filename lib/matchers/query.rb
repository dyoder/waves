module Waves

  module Matchers

    class Query < Base
      
      def initialize( pattern ) ; @query = pattern or {} ; end
    
      def call( pattern )
        query = request.query
        pattern.all? do | key, val |
          ( val.is_a? Proc and val.call( query[ key ] ) ) or val === query.key
        end
      end
      
    end
    
  end
  
end