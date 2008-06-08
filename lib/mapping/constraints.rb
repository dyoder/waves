module Waves

  module Mapping
    
    class Constraints
      
      # TODO: Add other header methods here ... 
      # may include some shortcuts for accessing Rack vars also
      METHODS = %w( method accepts ).map( &:intern )
      
      attr_accessor *METHODS
      
      def initialize( options )
        METHODS.each do |method|
          send( "#{method}=", options[method] ) if options[method]
        end
      end
      
      def satisfy?( request )
        METHODS.all? do |method|
          wanted = send( method )
          got = request.send( method )
          wanted == got if wanted == got
        end
      end
            
    end

  end

end
