module Waves
  
  module Resources
    
    class NoMatchingResourceError < RuntimeError
      def initialize( request )
        super( request.path )
      end
    end
    
    class Selector
      
      #
      # TODO: Path generation stuff has been taken out until we work out the right design.
      #
      
      include Functor::Method
      
      def initialize ; @rules = [] ; end
      functor( :direct, Symbol ) { | resource | direct( :to => resource ) }
      functor( :direct, Array ) { | path | direct( :path => path ) }
      functor( :direct, Array, Hash ) { | path, options | options[ :path ] = path ; direct( options ) }
      functor( :direct, Hash ) { | options | @rules << resolver(  options ) }
      
      def resolver( options )
        matcher = Waves::Matchers::Request.new( options )
        lambda do | request |
          if matcher.call( request )
            resource = ( resolve( options[:to] ) or resolve( true ) ).new( request )
            ( resolve( options[:through] ).new( resource, request ) if options[:through] ) or resource
          end
        end
      end
      functor( :resolve, Symbol ) { | resource | Waves.main::Resources[ resource ] }
      functor( :resolve, Class ) { | resource | resource }
      functor( :resolve, nil ) { false }
      functor( :resolve, true ) do
        resolve( request.traits.waves.resource ||
          request.traits.waves.resources.to_s.singular )
      end
      
      def []( request ) ; call( request ); end
      
      # given a request, find the right resource
      def call( request )
        @rules.each do | rule | 
          resource = rule.call( request )
          return resource if resource
        end
        raise NoMatchingResourceError.new( request )
      end
            
      
    end
      
  end

end
