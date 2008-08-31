module Waves

  module Matchers
    
    # In a Waves mapping, the Pattern is the structure used to match the path of the request URI.
    # 
    # A Pattern consists of an array where each element corresponds to a path component in a request URI.
    
    class Path < Base
      
      include Functor::Method
      
      # Takes an array of pattern elements ... coming soon, support for formatted strings!
      def initialize( pattern ) ; @pattern = pattern ; end

      functor( :call, Waves::Request ) { | request | call( @pattern, request.path ) }
      # when the pattern array is omitted, match on any path
      functor( :call, nil, String ) { |pattern, path| {} }
      # an empty pattern array matches root, i.e. "/"
      functor( :call, [], '/' ) { | pattern, path | {} }
      functor( :call, [], Array ) { false }
      # otherwise break the path down into an array and match arrays
      functor( :call, Array, String ) { | pattern, path | call( pattern, path.split('/')[1..-1] ) }
      # this variation should never come up ... right?
      functor( :call, Array, nil ) { | pattern, path | nil }
      # alright, now we are into the general case, matching two arrays ...
      functor( :call, Array, Array ) do | wants, gots |
        if wants.length > gots.length
          # pad gots with nils so they are the same length
          gots = ( gots + ( [nil] * ( wants.length - gots.length ) ) )
        elsif wants.length < gots.length
          # true is a wildcard matcher ...
          return false unless wants.last == true or 
            ( wants.last.respond_to? :values and wants.last.values.first == true )
          # pad wants with last so they are the same length
          wants = ( wants + ( [ wants.last ] * ( gots.length - wants.length ) ) )
        end
        r = {}; r if wants.zip( gots ).all? { |want, got| match( r, want, got ) }
      end
      functor( :call, Hash, String, String ) { | r, want, got | got if want == got }
      functor( :call, Hash, Regexp, String ) { | r, want, got | got if want === got }
      # a symbol matches pretty much anything and stores it as a param ...
      functor( :call, Hash, Symbol, String ) do | r, want, got | 
        r[ want.to_s ] = match( r, /^(\S+)$/, got )
      end
      functor( :call, Hash, true, Object ) do | r, key, got | 
        r[ true ] ||= []; r[ true ] << got
      end
      
      # a hash is either a param with a custom regexp or a default value ...
      functor( :call, Hash, Hash, Object ) do | r, want, got |
        key, want = want.to_a.first ; match( r, key, want, got )
      end
      functor( :call, Hash, Symbol, String, String ) do | r, key, want, got |
        r[ key.to_s ] = got
      end
      functor( :call, Hash, Symbol, String, nil ) do | r, key, want, got |
        r[ key.to_s ] = want
      end
      functor( :call, Hash, Symbol, true, Object ) do | r, key, want, got |
        r[ key.to_s ] ||= []; r[ key.to_s ] << got
      end
      functor( :call, Hash, Symbol, Regexp, String ) do | r, key, want, got |
        r[ key.to_s ] = match( r, want, got )
      end
      functor( :call, Hash, Symbol, Regexp, nil ) do | r, key, want, got |
        false
      end
      functor( :call, Hash, Object, nil ) { | r, want, got | false }      
    end

  end

end
