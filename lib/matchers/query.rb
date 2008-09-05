module Waves

  module Matchers

    class Query < Base
      
      def initialize( pattern ) ; @pattern = ( pattern or {} ) ; end
    
      def call( request )
        @pattern.all? do | key, val |
          ( val.is_a? Proc and val.call( request.params[ key ] ) ) or val === request.params[ key ]
        end
      end
      
    end
    
  end
  
end