require 'markaby'

::Markaby::Builder.set( :indent, 2 )

module Waves

  module Renderers

    class Markaby

      include Renderers::Mixin

      extension :mab

      # capture needed here for content fragments, otherwise
      # you'll just get the last tag's output ...
      # def self.capture( template )
      #  "capture { #{template} }"
      # end

      def self.render( path, assigns )
        builder = ::Markaby::Builder.new( assigns )
        helper = helper( path )
        builder.meta_eval { include( helper ) }
        builder.instance_eval( template( path ) )
        builder.to_s
      end

    end

  end

end
