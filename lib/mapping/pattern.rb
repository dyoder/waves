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
       returning( Hash.new ) { | r | @keys.zip( m[1..-1] ) { | k, v | r[ k ] = v } }
      end
      
      private
      
      functor( :compile, Array ) do | path |
        @generator = lambda { |*args| self.instance_eval { generate( path, args )  } }
        @pattern = Regexp.new( path.map { |component| compile( component ) }.join('/') )
      end
      
      functor( :compile, String ) { |s| Regexp.escape( s ) }
      functor( :compile, Regexp ) { |re| s }
      functor( :compile, Symbol ) { |sy| @keys << sy.to_s ; '([\w\_\-\#]+)' }

      functor( :generate, Array, Array ) { | keys, vals | keys.map { |key| generate( key, vals ) }.join('/') }
      functor( :generate, :resource, Array ) { | key, vals | resource }
      functor( :generate, :resources, Array ) { | key, vals | resources }
      functor( :generate, Symbol, Array ) { | key, vals | generate( key, vals.shift ) }
      functor( :generate, Symbol, Symbol ) { | key, val | val }
      functor( :generate, Regexp, Array ) { | key, vals | raise ArgumentError.new( "Can't generate a path from Regexp." ) }
      
    end

  end

end
