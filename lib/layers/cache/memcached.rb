#--
# Waves::Layers::Cache::MemcachedCache
# File: lib/layers/cache/memcached.rb
#++
# Framework layer to access your memcached server(s). The specific gem we use is 'memcached'.
# We basically stay out of the way, so check 'http://blog.evanweaver.com/files/doc/fauna/memcached/classes/Memcached.html'
# for precise uses.

module Waves

  module Layers

    module Cache

      class MemcachedCache < Waves::Cache
        require 'memcached'
        
        def initialize(servers, opt = {})
        # Waves::Layers::Cache::MemcachedCache.new is the same format as Memcached.new
          @memcached = Memcached.new(servers, opt)
        end

        def add(key,value, ttl = 0, marshal = true)
          @memcached.add(key.to_s,value,ttl,marshal)
        end

        def get(key)
          @memcached.get(key.to_s)
        end

        def delete(*keys)
          keys.each {|key| @memcached.delete(key.to_s) }
        end

        def clear
          @memcached.flush
        end

        alias_method :store, :add   # Override our natural Waves::Cache :store method with Memcache's :add
        alias_method :fetch, :get   # Override our natural Waves::Cache :fetch method with Memcache's :get

        def method_missing(*args, &block)
          @memcached.__send__(*args, &block)
        rescue MemCache::MemCacheError => e
          Log.error e.to_s
          nil
        end


      end

    end

  end

end