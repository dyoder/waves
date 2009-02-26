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
        return false if not request.ext
        if(@constraints[:ext].class == Array)
          return @constraints[:ext].any?{ |ext|  Waves.config.mime_types.mapping[ '.' + ext.to_s ] == request.ext }
        else 
          return Waves.config.mime_types.mapping[ '.' + @constraints[:ext] ] == request.ext
        end
      end

    end

  end

end
