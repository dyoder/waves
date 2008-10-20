require 'caches/synchronized'

module Waves
  module Caches

    class File < Simple

      def initialize( args )
        raise ArgumentError, ":directory is nil" if args[ :directory ].nil?
        @directory = args[ :directory ] ; @keys = []
      end

      def store( key, value )            
        @keys << key
        ::File.open( @directory / key, 'w') { |f| Marshal.dump( value, f ) }
      end

      def delete( key )
        if @keys.include? key
          ::File.delete( @directory / key )
          @keys.delete( key )
        end
      end

      def clear
        @keys.each { |key| delete( key ) }
      end

      def fetch( key )
        Marshal.load( ::File.read( @directory / key ) ) if @keys.include?( key )
      rescue ArgumentError
        nil
      end
      
    end
    
    class SynchronizedFile < Synchronized
      
      def initialize( args )
        super( File.new( args ) )
      end
      
    end
    
  end
end


