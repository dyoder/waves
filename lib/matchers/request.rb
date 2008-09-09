module Waves

  module Matchers

    class Request < Base
      
      def initialize( options )
        @constraints = {
          :content_type => Matchers::ContentType.new( options[ :content_type ] ),
          :accept => Matchers::Accepts.new( options ), 
          :uri => Matchers::URI.new( options ), 
          :query => Matchers::Query.new( options[:query] )
        }
      end
    
      # after test is called, traits.waves will contain the extracted path_params, if any,
      # so we do a little bookkeeping to ensure that the waves.rest trait is set properly
      def call( request )
        if test( request )
          traits = request.traits.waves
          if traits.path_params.rest
            traits.rest = traits.path_params.rest
            traits.path_params.rest = nil
          else
            traits.rest = '/'
          end          
          return true
        end
      end
      
    end
    
  end
  
end