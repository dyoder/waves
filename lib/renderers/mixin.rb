module Waves

  module Renderers # :nodoc:

    # The renderers mixin provides a number of methods to simplify writing new renderers.
    # Just include this in your Renderer class and write your render method.
    module Mixin

      # Adds the following methods to the mod class:
      #
      # - extension: allows you to set or get the extension used by this renderer.
      #
      #     Renderers::Markaby.extension 'foo' # tell Waves to use .foo as Markaby extension
      #
      # - filename: generate a filename for the template based on a logical path.
      # - template: read the template from the file corresponding to the given logical path.
      # - helper: return a helper module that corresponds to the given logical path.
      #
      def self.included(mod)
        
        # Register the renderer with the Views module
        Views.renderers << mod

        def mod.extension(*args)
          return @extension if args.length == 0
          @extension = args.first
        end

        def mod.filename(path)
          :templates / "#{path}.#{self.extension}"
        end

        def mod.render(path,args=nil)
        end

        def mod.template( path )
          File.read( filename( path ) )
        end

        def mod.helper( path )
          Waves.main[ :helpers ][ File.basename( File.dirname( path ) ).camel_case ]
        end
      end

    end

  end

end
