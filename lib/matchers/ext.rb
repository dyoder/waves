module Waves

  module Matchers

    class Ext < Base

      def initialize(ext)
        @constraints = {
          :ext => ext
        }

      end

      def call( request )
        return true if not @constraints[:ext]
        return Waves.config.mime_types.mapping[ '.' + @constraints[:ext].to_s ] == request.ext
      end

    end

  end

end
