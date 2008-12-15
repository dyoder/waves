module Waves

  module Matchers

    class Request < Base
      
      def initialize( options )
        @uri = Matchers::URI.new( options )
        @constraints = {
          :content_type => Matchers::ContentType.new( options[ :content_type ] ),
          :accept => Matchers::Accept.new( options ),
          :query => Matchers::Query.new( options[:query] ),
          :traits => Matchers::Traits.new( options[:traits] )
        }
      end

      def call( request )
        if test( request ) and captured = @uri[ request ]
          request.traits.waves.captured = captured
        end
      end
          
    end
    
  end
  
end