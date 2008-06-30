require 'generator'

module Waves

  module Mapping
    
    class Pattern
      
      include Functor::Method
      
      def initialize( options ) ; @pattern = options[ :path ] ; end
      
      functor( :match, Waves::Request ) { | request | match( @pattern, request.path ) }
      functor( :match, nil, String ) { |patern, path| {} }
      functor( :match, Array, String ) { | pattern, path | match( pattern, path.split('/')[1..-1] ) }
      functor( :match, Array, Array ) do | wants, gots |
        r = {}; matches = wants.all? { | want | match( r, want, gots.shift ) }
        r if matches and gots.empty?
      end
      functor( :match, Hash, String, String ) { | r, want, got | got if want == got }
      functor( :match, Hash, Regexp, String ) { | r, want, got | got if want === got }
      functor( :match, Hash, Symbol, String ) do | r, want, got | 
        r[ want.to_s ] = got if match( r, /([\w\_\-\#]+)/, got )
      end
      functor( :match, Hash, Hash, String ) do | r, want, got | 
        key = want.keys.first
        r[ key.to_s ] = match( r, key, got )
      end
      # hashes represent optional values with a default
      functor( :match, Hash, Hash, nil ) { | r, want, got | r[ want.keys.first.to_s ] = want.values.first }
      # everything else is mandatory ...
      functor( :match, Hash, Object, nil ) { | r, want, got | false }
      
    end

  end

end
