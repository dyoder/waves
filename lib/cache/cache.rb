#!waves#########/0.8.0/##\|/4V35###
# a Waves Cache brought to you by ab5tract
# :This is the Cache API. Do as you will, so long as you return what I do.
###################################

module Waves

  class Cache

    # Exception classes
    class KeyMissing < StandardError; end
    
    def initialize
      @cache = {}
    end
    
    # Universal to all cache objects.
    def [](key)
      if Waves.config.synchronize?
        Waves.synchronize _fetch(key)
      else
        _fetch(key)
      end
    end

    def []=(key,value)
      if Waves.config.synchronize? 
        Waves.synchronize _store(key,value)
      else
        _store(key,value)
      end
    end
 
    def exists?(key)
      if Waves.config.synchronize?
        Waves.synchronize _fetch(key)
      else
        _fetch(key)
      end
    rescue KeyMissing
      return false
    else
      return true
    end

    alias_method :exist?, :exists?

    # Replicate the same capabilities in any descendent of Waves::Cache for API compatibility.    
    
    def store(key, value, ttl = {})
      Waves.synchronize do
      @cache[key] = {
        :expires => ttl.kind_of?(Numeric) ? Time.now + ttl : nil,
        :value => value
      }
      end
    end

    def delete(*keys)
     Waves.synchronize { keys.each {|key| @cache.delete(key) }}
    end

    def clear
      Waves.synchronize { @cache.clear }
    end

    def fetch(key)
      Waves.synchronize do

      raise KeyMissing, "#{key} doesn't exist in cache" if @cache.has_key?(key) == false
      return @cache[key][:value] if @cache[key][:expires].nil?
      
      if @cache[key][:expires] > Time.now
        @cache[key][:value]
      else
        delete key
        raise KeyMissing, "#{key} expired before access attempt"
      end

      end
    end

  end
end