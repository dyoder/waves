module Waves

  module Matchers

    class Resource
      
      def initialize( options )
        @matcher = Waves::Matchers::Request.new( options )
      end

      def call( resource ) ; @matcher.call( resource.request ) ; end
      def []( *args ) ; call( *args ) ; end
      
          
    end
    
  end
  
end