module Waves

  module Mapping
    
    class Constraints
      
      METHODS = %w( domain scheme method accept ).map( &:intern )
      
      def initialize( options )
        METHODS.each do | method |
          instance_variable_set( "@#{method}", options[ method ] ) if options[ method ]
        end
      end
      
      def satisfy?( request )
        METHODS.all? do | method |
          wanted = instance_variable_get( "@#{method}")
          got = request.send( method ) if wanted
          # wanted === got
          wanted.is_a?( Proc) ? wanted.call( got ) : got === wanted
        end
      end
            
    end

  end

end
