require 'memcached'
module Waves
  module Caches
    class Memcached < Simple

      def initialize( args )
        raise ArgumentError, ":servers is nil" if args[ :servers ].nil?
        @cache = ::Memcached.new( args[ :servers ], args[ :options ] || {} )
      end

      def store( key,value, ttl = 0, marshal = true )
        cache = @cache.clone;  cache.add( key.to_s, value, ttl, marshal );  cache.destroy
      end

      def fetch( key )
        cache = @cache.clone;  cache.get( key.to_s );  cache.destroy
      rescue ::Memcached::NotFound => e
        nil
      end

      def delete( key )
        cache = @cache.clone; cache.delete( key.to_s );  cache.destroy
      end

      def clear
        cache = @cache.clone;  cache.flush;  cache.destroy
      end

    end
    
    class SynchronizedMemcached < Synchronized
      
      def initialize( args )
        super( Memcached.new( args ) )
      end
      
    end

  end
end