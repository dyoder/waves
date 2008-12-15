module Waves

  module Renderers # :nodoc:

    # The renderers mixin provides a number of methods to simplify writing new renderers.
    # Just include this in your Renderer class and write your render method.
    module Mixin

      # Adds the following methods to the mod class:
      #
      # - filename: generate a filename for the template based on a logical path.
      # - template: read the template from the file corresponding to the given logical path.
      # - helper: return a helper module that corresponds to the given logical path.
      #

      def included( app )
        Waves::Views.renderers << self
      end

      def filename(path)
        "#{path}.#{self::Extension}"
      end

      def template( path )
        File.read( filename( path ) )
      end

      def helper( path )
        Waves.main[ :helpers ][ File.basename( File.dirname( path ) ).camel_case ]
      end

    end

  end

end
