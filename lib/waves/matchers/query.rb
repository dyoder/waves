module Waves

  module Matchers

    class Query < Base
      
      def initialize( pattern ) ; @pattern = ( pattern or {} ) ; end
    
      def call( request )
        @pattern.all? do | key, val |
          key = key.to_s
          ( ( val.respond_to?(:call) and val.call( request.query[ key ] ) ) or 
            ( request.query[ key ] and ( ( val == true ) or ( val === request.query[ key ] ) ) ) )
        end
      end
      
    end
    
  end
  
end