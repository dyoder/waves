module Waves
  module Cache

    class Memcached < Waves::Cache::API
      require 'memcached'

      def initialize(args)
        # initialize takes what you would throw at Memcached.new

        raise ArgumentError, "need :servers to not be nil" if args[:servers].nil?
        args[:opt] = args.has_key?(:opt) ? args[:opt] : {}
        @cache = ::Memcached.new(args[:servers], args[:opt])
      end

      def add(key,value, ttl = 0, marshal = true)
        @cache.add(key.to_s,value,ttl,marshal)
      end

      def get(key)
        @cache.get(key.to_s)
      rescue ::Memcached::NotFound => e
        # In order to keep the Memcached layer compliant with Waves::Cache...
        # ...we need to be able to expect that an absent key raises KeyMissing
        raise KeyMissing, "#{key} doesn't exist, #{e}"
      end

      def delete(*keys)
        keys.each {|key| @cache.delete(key.to_s) }
      end

      def clear
        @cache.flush
      end

      alias_method :store, :add   # Override our natural Waves::Cache :store method with Memcache's :add
      alias_method :fetch, :get   # Override our natural Waves::Cache :fetch method with Memcache's :get

      def method_missing(*args, &block)
        @cached.__send__(*args, &block)
      rescue => e
        Waves::Logger.error e.to_s
        nil
      end

    end

  end
end