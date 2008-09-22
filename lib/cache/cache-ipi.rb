###################################
# a Waves Cache brought to you by ab5tract
# :This is the Cache iPi. "Do as you will, return what verify expects."
# :(In this case it's just a hash, but in the end who knows? Follow the iPi trail and see where it goes)
###################################

module Waves

  module Cache
    # Exception classes
    class KeyMissing < StandardError; end
    class KeyExpired < StandardError; end

    def self.new
      Waves::Cache::IPI.new
    end
    
    class IPI

      def initialize
        @cache = {}  #raise TriedBoth
      end

      # Universal to all cache objects.
      def [](key)
        fetch(key)
      end

      def []=(key,value)  #:TODO:add optional hash argument *params
        store(key,value )
      end

      def exists?(key)
        true if fetch(key)
      rescue KeyMissing, KeyExpired
        false
      end

      alias_method :exist?, :exists?

      # Replicate the same capabilities in any descendent of Waves::Cache for API compatibility.

      def store(key, value, ttl = nil)
        item = { :value => value }
        item[ :expires ] = Time.now + ttl if ttl
        Waves.synchronize { @cache[key] = item }
      rescue TypeError => e
        raise e, "The ttl value must be convertable to a float"
      end

      def delete(*keys)
       Waves.synchronize { keys.each { |key| @cache.delete(key) } }
      end

      def clear
        Waves.synchronize { @cache.clear }
      end

      def fetch(key)    # :TODO: Should probably take a splat
        Waves.synchronize do
          raise KeyMissing unless item = @cache[ key ]
          if item[:expires] and item[:expires] < Time.now
            @cache.delete( key ) and raise KeyExpired 
          end
          item[:value]
        end

      end

    end
  end

end
