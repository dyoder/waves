module Waves

  module Matchers

    class Request < Base
      
      def initialize( options )
        @constraints = {
          :content_type => Matchers::ContentType.new( options[ :content_type ] ),
          :accepts => Matchers::Accepts.new( options ), 
          :uri => Matchers::URI.new( options ), 
          :query => Matchers::Query.new( options[:query] )
        }
      end
    
      def call( request ) ; test( request ) ; end
      
    end
    
  end
  
end