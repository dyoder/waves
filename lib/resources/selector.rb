module Waves
  
  module Resources
    
    class NoMatchingResourceError < RuntimeError
      def initialize( request )
        super( request.path )
      end
    end
    
    class Selector
      
      include Functor::Method
      
      def initialize ; @rules = [] ; @paths = {} ; end

      def []( request ) ; call( request ); end
      
      # given a request, find the right resource
      functor( :call, Waves::Request ) do | request |
        @rules.each do | resource, constraint |
          return resource if constraint[ request ]
        end
        raise NoMatchingResourceError.new( request )
      end
      
      # given a resource, find the path prefix 
      # used to generate paths
      functor( :call, Class ) do | resource |
        @paths[ resource ]
      end
      
      # given a resource and a mount name, find the path prefix
      functor( :call, Class, Symbol ) do | resource, mount |
        @paths[ [ resource, mount ] ]
      end
      
      functor( :mount, Class, Array ) do | res, path | 
        @rules << [ res, Waves::Matchers::Path.new( path ) ]
        @paths[ [ res, nil ] ] = path
      end
      
      functor( :mount, Class, Hash ) do | res, opts | 
        @rules << [ res, Waves::Matchers::Request.new( opts ) ]
        @paths[ [ res, opts[ :as ] ] ] = opts[ :path ]
      end

      functor( :mount, Symbol, Array ) do | res, path |
        mount( app::Resources[res], path )
      end
      
      functor( :mount, Symbol, Hash ) do | res, opts | 
        mount( app::Resources[res], opts )
      end
            
    end
      
  end

end
