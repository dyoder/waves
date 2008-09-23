module Waves
  module Cache

    class Memcached < Waves::Cache::IPI
      require 'memcached'

      def initialize(args)
        # initialize takes what you would throw at Memcached.new

        raise ArgumentError, "need :servers to not be nil" if args[:servers].nil?
        args[:opt] = args.has_key?(:opt) ? args[:opt] : {}
        @cache = ::Memcached.new(args[:servers], args[:opt])
      end

      def store(key,value, ttl = 0, marshal = true)
        Waves.synchronize { cache = @cache.clone;  cache.add(key.to_s,value,ttl,marshal);  cache.destroy }
      end

      def fetch(key)
        Waves.synchronize { cache = @cache.clone;  cache.get(key.to_s);  cache.destroy }
      rescue ::Memcached::NotFound => e
        # In order to keep the Memcached layer compliant with Waves::Cache...
        # ...we need to be able to expect that an absent key raises KeyMissing
        raise KeyMissing, "#{key} doesn't exist, #{e}"
      end

      def delete(*keys)
        keys.each {|key| Waves.synchronize { cache = @cache.clone; cache.delete(key.to_s) };  cache.destroy }
      end

      def clear
        Waves.synchronize { cache = @cache.clone;  cache.flush;  cache.destroy }
      end

    end

  end
end