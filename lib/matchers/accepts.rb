module Waves

  module Matchers

    class Accepts < Base
      
      def initialize( options )
        @constraints = {
          :accept => options[ :accepts ],
          :lang => options[ :lang ],
          :charset => options[ :charset ]
        }
      end
    
      def call( request ) ; test( request ) ; end
      
    end
    
  end
  
end