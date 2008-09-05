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
        resource, constraint = @rules.find do | resource, constraint |
          request.blackboard.waves = {}
          constraint[ request ]
        end
        raise NoMatchingResourceError.new( request ) unless resource
        params = request.blackboard.waves.path_params
        if params[:rest]
          request.blackboard.waves.rest = params[:rest]
          params.delete(:rest)
        else
          request.blackboard.waves.rest = '/'
        end
        if params[:resource]
          resource = params[:resource] if resource == true
          params.delete(:resource)
        elsif params[:resources]
          resource = params[:resources].singular if resource == true
          params.delete(:resources)
        end
        ( ( resource.is_a? Class and resource ) or Waves.main::Resources[ resource ] ).new( request )
      end
      
      # given a resource, find the path prefix 
      # used to generate paths
      functor( :call, Class, nil ) do | resource |
        @paths[ [ resource, nil ] ]
      end
      
      # given a resource and a mount name, find the path prefix
      functor( :call, Class, Symbol ) do | resource, mount |
        @paths[ [ resource, mount ] ]
      end
      
      resource = lambda { |x| x.is_a? Class or x.is_a? Symbol or x == true }
      functor( :mount, resource, Array ) do | res, path | 
        @rules << [ res, Waves::Matchers::Path.new( path ) ]
        @paths[ [ res, nil ] ] = path
      end
      
      functor( :mount, resource, Hash ) do | res, opts | 
        @rules << [ res, Waves::Matchers::Request.new( opts ) ]
        @paths[ [ res, opts[ :as ] ] ] = opts[ :path ]
      end
      
      functor( :mount, resource, Array, Hash ) do | res, path, opts | 
        opts[ :path ] = path ; mount( res, opts )
      end
      
    end
      
  end

end
