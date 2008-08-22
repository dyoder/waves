module Waves
  
  module Resources
    
    class Proxy
      
      include Mixin
      
      def initialize( request ) 
        @request = request
        @resource = Waves.main[:resources][ resource ].new( request )
      end
      
      def resource
        params['resource'] || params['resources'].singular
      rescue NoMethodError
        :default
      end
      
      def resources
        params['resources'] || params['resource'].plural
      end
      
      alias_method :singular, :resource
      alias_method :plural, :resources
      
      def method_missing( name, *args, &block )
        @resource.send( name, *args, &block )
      end
  
    end
    
  end
      
end      