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
      functor( :match, [], Array ) { false }
      # otherwise break the path down into an array and match arrays
      functor( :match, Array, String ) { | pattern, path | match( pattern, path.split('/')[1..-1] ) }
      # this variation should never come up ... right?
      functor( :match, Array, nil ) { | pattern, path | nil }
      # alright, now we are into the general case, matching two arrays ...
      functor( :match, Array, Array ) do | wants, gots |
        if wants.length > gots.length
          # pad gots with nils so they are the same length
          gots = ( gots + ( [nil] * ( wants.length - gots.length ) ) )
        elsif wants.length < gots.length
          
          # true is a wildcard matcher ...
          return false unless wants.last == true
          # # special case where true is the entire pattern
          # return { true => gots } if wants.size == 1
          # # collapse last n elements down to an array to match true
          # r[ true ] = gots[ wants.size-2..-1 ]
          # gots = gots[ 0..wants.size-2 ]
          
          # pad wants with last so they are the same length
          wants = ( wants + ( [ wants.last ] * ( gots.length - wants.length ) ) )
        end
        r = {}; r if wants.zip( gots ).all? { |want, got| match( r, want, got ) }
      end
      functor( :match, Hash, String, String ) { | r, want, got | got if want == got }
      functor( :match, Hash, Regexp, String ) { | r, want, got | got if want === got }
      # a symbol matches pretty much anything and stores it as a param ...
      functor( :match, Hash, Symbol, String ) do | r, want, got | 
        r[ want.to_s ] = match( r, /^(\S+)$/, got )
      end
      functor( :match, Hash, true, Object ) do | r, key, got | 
        r[ true ] ||= []; r[ true ] << got
      end
      # a hash is either a param with a custom regexp or a default value ...
      functor( :match, Hash, Hash, Object ) do | r, want, got |
        key, want = want.first ; match( r, key, want, got )
      end
      functor( :match, Hash, Symbol, String, String ) do | r, key, want, got |
        r[ key.to_s ] = got
      end
      functor( :match, Hash, Symbol, String, nil ) do | r, key, want, got |
        r[ key.to_s ] = want
      end
      functor( :match, Hash, Symbol, true, Object ) do | r, key, want, got |
        r[ key.to_s ] ||= []; r[ key.to_s ] << got
      end
      functor( :match, Hash, Symbol, Regexp, String ) do | r, key, want, got |
        r[ key.to_s ] = match( r, want, got )
      end
      functor( :match, Hash, Symbol, Regexp, nil ) do | r, key, want, got |
        false
      end
      
    end

  end

end
