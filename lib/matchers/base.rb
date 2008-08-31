module Waves

  module Matchers

    class Base < Proc
      
      attr_accessor :constraints
      
      # used to provide consisting matching logic across all matchers
      def test( request )
        constraints.all? do | key, val |
          val.nil? or ( val.is_a? Proc and val.call( request ) ) or 
            val == request.send( key ) or val === request.send( key )
        end
      end
      
    end
    
  end
  
end