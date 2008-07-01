require 'haml'

module Waves

  module Renderers

    class Scope
      include Waves::Helpers::Common
      include Waves::Helpers::Model
      include Waves::Helpers::TagHelper
      include Waves::Helpers::UrlHelper
      include Waves::Helpers::View

      def <<(s)
        eval("@haml_buffer", @binding).push_text s # add to rendered output
      end

      def capture(&block)
        capture_haml(nil, &block)
      end

    end

    class Haml

      include Renderers::Mixin

      extension :haml

      def self.render( path, assigns )
        engine = ::Haml::Engine.new( template( path ) )
        scope = Scope.new
        helper = helper( path )
        scope.meta_eval { include( helper ) }
        scope.instance_eval do
          assigns.each { |key,val| instance_variable_set("@#{key}",val) unless key == :request }
        end
        engine.render(scope, assigns)
      end

    end

  end

end
