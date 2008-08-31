module Waves

  module Matchers

    class URI < Base
      
      def initialize( options )
        @path = Waves::Matchers::Path.new( options[ :path ] )
        constraints = { :server => options[ :server ], :scheme => options[ :scheme ] }
      end
    
      def call( request ) ; @path.call( request ) and test( request ) ; end
      
    end
    
  end
  
end