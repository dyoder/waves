module Waves
  
  module Resources
    
    class Delegate
      
      include Waves::Resources::Mixin
      def initialize( request, resource ) ; @request = request ; @resource = resource ; end
      def post ; @resource.post( @request ) ; end
      def get ; @resource.get( @request ) ; end
      def put ; @resource.put( @request ) ; end
      def delete ; @resource.delete( @request ) ; end
      
    end
    
  end
  
end