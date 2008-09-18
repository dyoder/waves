module Waves
  
  module Resources
    
    class Delegate
      
      include Waves::Resources::Mixin
      def initialize( resource, request ) ; @request = request ; @resource = resource ; end
      
      %w( post get put delete before after ).each do | m |
        functor( m ) { @resource.send( m ) }
      end
      
    end
    
  end
  
end