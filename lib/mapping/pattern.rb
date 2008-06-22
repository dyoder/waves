require 'generator'

module Waves

  module Mapping
    
    class Pattern
      
      include Functor::Method
      
      attr_accessor :target, :pattern, :generator
      
      def initialize( options )
        @keys = [] ; @target = options[ :target ]
        compile( options[ :pattern ] )
      end
      
      def match( request )
       return false unless m = @pattern.match( request.send( target ) )
       zip( @keys, m[1..-1] )
      end
      
      private
      
      functor( :compile, Array ) do | path |
        @generator = lambda { |*args| self.instance_eval { generate( path, args )  } }
        @pattern = Regexp.new( '^/' + path.map { |component| compile( component ) }.join('/') + '/?$' )
      end
      
      functor( :compile, String ) { |s| Regexp.escape( s ) }
      functor( :compile, Regexp ) { |re| s }
      functor( :compile, Symbol ) { |sy| @keys << sy.to_s ; '([\w\_\-\#]+)' }
      functor( :compile, Hash ) { |h| @keys << h; '([\w\_\-\#]+)?' }

      # this is a bit different than Array#zip ...
      functor( :zip, Array, Array ) { | keys, vals | keys.inject( {} ) { | h, key | n, m = zip( key, vals ) ; h[ n ] = m ; h } }
      functor( :zip, String, Array ) { | key, vals | [ key, vals.shift ] }
      functor( :zip, Hash, Array ) { | h, vals | key = h.keys.first ; [ key.to_s, ( vals.shift || h[ key ] ) ] }

      functor( :generate, Array, Array ) { | keys, vals | keys.map { |key| generate( key, vals ) }.compact.join('/') }
      functor( :generate, :resource, Array ) { | key, vals | resource }
      functor( :generate, :resources, Array ) { | key, vals | resources }
      functor( :generate, Symbol, Array ) { | key, vals | generate( key, vals.shift ) }
      functor( :generate, Symbol, Symbol ) { | key, val | val }
      functor( :generate, Regexp, Array ) { | key, vals | nil }
      functor( :generate, Hash, Array ) { | h, vals | vals.shift || h.values.first }
      
    end

  end

end
