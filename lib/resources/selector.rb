module Waves
  
  module Resources
    
    class NoMatchingResourceError < RuntimeError
      def initialize( request )
        super( request.path )
      end
    end
    
    class Selector
      
      include Functor::Method
      
      def initialize( mapping ) 
        mapping.each do | constraints, resource |
          meta_eval do
            functor( :resource, matcher( constraints ) ) { | request | resolve( resource ).new( request ) }
            functor( :path, resource ) { | resource | ( constraints.is_a? Array and constraints ) or [] }
          end
        end
        functor( :resource, Object ) { | request | raise NoMatchingResourceError.new( request ) }
      end
      
      def []( request ) ; resource( request ) ; end
      
      functor( :matcher, Array ) { | path | Waves::Matchers::Path.new( path ) }
      functor( :matcher, Hash ) { | options | Waves::Matchers::Request.new( options ) }
      
      functor( :resolve, Symbol ) { | name | Waves.app::Resources[ name ] }
      functor( :resolve, Class ) { | klass | klass }
      
    end
      
  end

end
