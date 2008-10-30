module Waves

  module Controllers

    module Mixin

      attr_reader :request

      include Waves::ResponseMixin

      def initialize( request )
        @request = request
      end
      
      def find( name )
        model.find( name )
      end
      
      def create( attributes )
        model.create( attributes )
      end
      
      def update( name, attributes )
        find( name ).attributes = attributes
      end
      
      def delete( name )
        model.delete( name )
      end
      
      def list
        model.all
      end

    end

    class Base ; include Mixin ; end 

  end

end
