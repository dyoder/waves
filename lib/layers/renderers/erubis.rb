require 'erubis'

module Waves
  
  module Renderers

    module Erubis
      
      Extension = :erb
      
      # extend Waves::Renderers::Mixin
      
      def self.included( app )
        Waves::Views.renderers << self
        Waves::Views::Base.send(:include, self::ViewMethods)
      end
      
      # def self.render( path, assigns={} )
      #   eruby = ::Erubis::Eruby.new( template( path ) )
      #   helper = helper( path )
      #   context = ::Erubis::Context.new( assigns )
      #   ( class << context ; self ; end ).module_eval do 
      #     include( helper )
      #     def << (s) ; s ; end
      #   end
      #   eruby.evaluate( context )
      # end
      
      module ViewMethods
        
        def erb(string, assigns={})
          eruby = ::Erubis::Eruby.new( string )
          helper = Waves.main::Helpers[self.class.basename]
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

end