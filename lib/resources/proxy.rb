module Waves
  
  module Resources
    
    class Proxy
      
      include Mixin
      
      def initialize( request ) 
        @request = request
        @resource = Waves.application[:resources][ resource ].new( request )
      end
      
      def resource
        params['resource'] || params['resources'].singular
      end
      
      def resources
        params['resources'] || params['resource'].plural
      end
      
      def method_missing( name, *args, &block )
        @resource.send( name, *args, &block )
      end
  
    end
    
  end
      
end      