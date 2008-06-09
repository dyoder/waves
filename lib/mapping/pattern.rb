module Waves

  module Mapping
    
    class Pattern
      
      attr_accessor :target, :pattern
      def initialize( options )
        @keys = [] ; @target = options[ :target ]
        @pattern = compile( option[ :pattern ] )
      end
      
      def match( request )
       return false unless m = pattern.match( request.send( target ) )
       params = [] ; @keys.zip( m ) { | key, val | r[ key ] = val } ; params
      end
      
      private
      
      functor( :compile, Regexp ) { |pattern| pattern }

      functor( :compile, String ) do | pattern |
        pattern = Regexp.escape( pattern ).gsub!( /<([\w\_\-\\]+)>/ ) { |match| @keys << match ; "(#{ match })" }
        "^#{pattern}/?$"
      end
      
            
    end

  end

end
