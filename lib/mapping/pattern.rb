module Waves

  module Mapping
    
    class Pattern
      
      attr_accessor :target, :pattern
      def initialize( options )
        @target = options[ :target ]
        @pattern = compile( option[ :pattern ] )
      end
      
      def match( request )
       ( m = pattern.match( request.send( target ) ) ) and m[1..-1]
      end
      
      private
      
      functor( :compile, Regexp ) { |pattern| pattern }

      functor( :compile, String ) do | pattern |
        pattern = Regexp.escape( pattern ).
          gsub!( /<([\w\_\-\\]+)>/ ) { |match| "(#{ match })" }
        "^#{pattern}/?$"
      end
      
            
    end

  end

end
