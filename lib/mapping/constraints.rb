module Waves

  module Mapping
    
    class Constraints
      
      # TODO: Add other header methods here ... 
      # may include some shortcuts for accessing Rack vars also
      METHODS = %w( method accept ).map( &:intern )
      
      attr_accessor *METHODS
      
      def initialize( options )
        METHODS.each do | method |
          instance_variable_set( "@#{method}", options[ method ] ) if options[ method ]
          send( "#{method}=", options[ method ] ) if options[ method ]
        end
      end
      
      def satisfy?( request )
        METHODS.all? do | method |
          wanted = self.send( method )
          got = request.send( method ) if wanted
          wanted == got
        end
      end
            
    end

  end

end
