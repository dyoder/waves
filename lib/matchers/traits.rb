module Waves

  module Matchers

    class Traits < Base
      
      def initialize( pattern ) ; @pattern = ( pattern or {} ) ; end
    
      def call( request )
        @pattern.all? do | key, val |
          ( val.is_a? Proc and val.call( request.traits[ key ] ) ) or val === request.traits[ key ]
        end
      end
      
    end
    
  end
  
end