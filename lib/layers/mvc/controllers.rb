module Waves

  module Controllers

    module Mixin

      attr_reader :request

      include Waves::ResponseMixin

      def initialize( request )
        @request = request
      end

    end

    # :)
    class Base ; include Mixin ; end 

  end

end
