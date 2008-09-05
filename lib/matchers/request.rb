module Waves

  module Matchers

    class Request < Base
      
      def initialize( options )
        @mount = options[ :as ] if options[ :as ]
        @constraints = {
          :content_type => Matchers::ContentType.new( options[ :content_type ] ),
          :accept => Matchers::Accepts.new( options ), 
          :uri => Matchers::URI.new( options ), 
          :query => Matchers::Query.new( options[:query] ),
          :mount => lambda { | request | request.blackboard.waves.mount == options[ :mount ] }
        }
      end
    
      def call( request )
        if test( request )
          request.params.merge!( request.blackboard.waves.path_params )
          request.blackboard.waves.mount ||= @mount
          return true
        end
      end
      
    end
    
  end
  
end