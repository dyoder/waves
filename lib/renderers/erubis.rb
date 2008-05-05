require 'erubis'

module Erubis
  
  # This is added to the Erubis Content class to allow the same helper methods
  # to be used with both Markaby and Erubis.
  class Context
    def <<(s) ; s ; end
  end
  
end
    
module Waves

  module Renderers
    
    class Erubis
      
      include Renderers::Mixin
      
      extension :erb

      def self.render( path, assigns )
        eruby = ::Erubis::Eruby.new( template( path ) )
        helper = helper( path )
        context = ::Erubis::Context.new
        context.meta_eval { include( helper ) ; }
        context.instance_eval do
          assigns.each do |key,val|
            instance_variable_set("@#{key}",val)
          end
        end
        eruby.evaluate( context )
      end
    
    end

  end
  
end