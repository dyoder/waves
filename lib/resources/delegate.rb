module Waves
  
  module Resources
    
    class Delegate
      
      include Waves::Resources::Mixin
      def initialize( request, resource ) ; @request = request ; @resource = resource ; end
      functor( :post ) { @resource.post( @request ) }
      functor( :get ) { @resource.get( @request ) }
      functor( :put ) { @resource.put( @request ) }
      functor( :delete ) { @resource.delete( @request ) }
      
    end
    
  end
  
end