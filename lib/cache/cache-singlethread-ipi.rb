#!waves#########/0.8.0/##\|/4^35###
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
        #Waves.synchronize { @cache = {} }
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
        fetch(key)
      rescue KeyMissing
        return false
      else
        return true
      end

      alias_method :exist?, :exists?

      # Replicate the same capabilities in any descendent of Waves::Cache for API compatibility.

      def store(key, value, ttl = {})
        @cache[key] = {
          :expires => ttl.kind_of?(Numeric) ? Time.now + ttl : nil,
          :value => value
        }
      end

      def delete(*keys)
       keys.each {|key| @cache.delete(key) }
      end

      def clear
        @cache.clear 
      end

      def fetch(key)    # :TODO: Should probably take a splat

          raise KeyMissing, "#{key} doesn't exist in cache" if @cache.has_key?(key) == false
          return @cache[key][:value] if @cache[key][:expires].nil?

          if @cache[key][:expires] > Time.now
            @cache[key][:value]
          else
            delete key
            raise KeyExpired, "#{key} expired before access attempt"
          end

      end

    end
  end

end
