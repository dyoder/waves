require 'erubis'

module Waves
  
  module Renderers

    module Erubis
      
      Extension = :erb
      
      extend Waves::Renderers::Mixin
      
      def self.render( path, assigns )
        eruby = ::Erubis::Eruby.new( template( path ) )
        helper = helper( path )
        context = ::Erubis::Context.new( assigns )
        ( class << context ; self ; end ).module_eval do 
          include( helper )
          def << (s) ; s ; end
        end
        eruby.evaluate( context )
      end


    end
  
  end

end