module Waves

  module Mapping
    
    class Descriptors
            
      def initialize( options )
        @threaded = options[ :threaded ]
      end
      
      def threaded? ; @threaded ; end
            
    end

  end

end
