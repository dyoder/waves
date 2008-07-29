require 'generator'

module Waves

  module Mapping
    
    class Pattern
      
      include Functor::Method
      
      def initialize( options ) ; @pattern = options[ :path ] ; end
      
      functor( :match, Waves::Request ) { | request | match( @pattern, request.path ) }
      # when the pattern array is omitted, match on any path
      functor( :match, nil, String ) { |pattern, path| {} }
      # an empty pattern array matches root, i.e. "/"
      functor( :match, [], '/' ) { | pattern, path | {} }
      functor( :match, Array, String ) { | pattern, path | match( pattern, path.split('/')[1..-1] ) }
      functor( :match, Array, nil ) { | pattern, path | nil }
      functor( :match, Array, Array ) do | wants, gots |
        r = {}; matches = wants.all? do | want | 
          if r[true] || want == true
            r[true] ||= []; r[true] << gots.shift
          else
            match( r, want, gots.shift )
          end
        end
        r if matches and gots.empty?
      end
      functor( :match, Hash, String, String ) { | r, want, got | got if want == got }
      functor( :match, Hash, Regexp, String ) { | r, want, got | got if want === got }
      # placeholder Symbols use a default regex for matching
      functor( :match, Hash, Symbol, String ) do | r, want, got | 
        r[ want.to_s ] = got if match( r, /^([\w\_\-\#]+)$/, got )
      end
      functor( :match, Hash, Hash, String ) do | r, want, got | 
        key = want.keys.first
        r[ key.to_s ] = got
      end
      # hashes represent optional values with a default
      functor( :match, Hash, Hash, nil ) { | r, want, got | r[ want.keys.first.to_s ] = want.values.first }
      # everything else is mandatory ...
      functor( :match, Hash, Object, nil ) { | r, want, got | false }
      
    end

  end

end
