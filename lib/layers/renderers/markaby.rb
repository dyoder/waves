module Waves
  
  module Renderers

    module Markaby
      
      Extension = :mab
      
      # extend Waves::Renderers::Mixin
      
      def self.included( app )
        require 'markaby'
        ::Markaby::Builder.set( :indent, 2 )
        Waves::Views.renderers << self
        Waves::Views::Base.send(:include, self::ViewMethods)
      end
      
      # def self.render( path, assigns )
      #   builder = ::Markaby::Builder.new( assigns )
      #   helper = helper( path )
      #   builder.meta_eval { include( helper ) }
      #   builder.instance_eval( template( path ) )
      #   builder.to_s
      # end
      
      module ViewMethods
        
        def mab(string, assigns={})
          builder = ::Markaby::Builder.new( assigns )
          helper = Waves.main::Helpers[self.class.basename]
          builder.meta_eval { include( helper ) }
          builder.instance_eval( string )
          builder.to_s
        end
        
      end
      


    end
  
  end

end