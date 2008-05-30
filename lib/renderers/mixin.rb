module Waves

  module Renderers

    # The renderers mixin provides a number of methods to simplify writing new renderers.
    # Just include this in your Renderer class and write your render method.
    module Mixin

      # Adds the following methods to the target class:
      #
      # - extension: allows you to set or get the extension used by this renderer.
      #
      #     Renderers::Markaby.extension 'foo' # tell Waves to use .foo as Markaby extension
      #
      # - filename: generate a filename for the template based on a logical path.
      # - template: read the template from the file corresponding to the given logical path.
      # - helper: return a helper module that corresponds to the given logical path.
      #
      def self.included(target)
        class << target

          def extension(*args)
            return @extension if args.length == 0
            @extension = args.first
          end

          def filename(path)
            :templates / "#{path}.#{self.extension}"
          end

          def render(path,args=nil)
          end

          def template( path )
            File.read( filename( path ) )
          end

          def helper( path )
            Waves.application.helpers[
              File.basename( File.dirname( path ) ).camel_case ]
          end
        end
      end


    end

  end

end
