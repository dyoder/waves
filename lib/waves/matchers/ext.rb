module Waves
  module Matchers

    class Ext < Base

      # Create file extension matcher.
      #
      # May be absent, in which case any or no extension is
      # accepted. Any specified extensions must be given as
      # Symbols without the dot.
      #
      # As a special case, if the extension Array contains
      # the empty String "", the matcher will match absence
      # of an extension.
      #
      # TODO: Enforce MIME lookup success? --rue
      #
      def initialize(ext)
        unless ext
          @constraints = {:ext => [], :noext => false}
          return
        end

        noext = ext.delete ""
        ext = Array(ext).map {|e| ".#{e.to_s}" }

        @constraints = {:ext => ext, :noext => noext}
      end

      # Match URL's file extension.
      #
      # @see  Ext#initialize for information.
      #
      def call(request)
        return true if @constraints[:ext].empty?

        if request.ext.empty?
          return true if @constraints[:noext]
          return false
        end

        return @constraints[:ext].any? {|ext| ext == request.ext }
      end

    end

  end

end
