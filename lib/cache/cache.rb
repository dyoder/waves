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
      if Waves.config.synchronize? 
        Waves.synchronize _store(key, value, ttl = {})
      else
        _store(key, value, ttl = {})
      end
    end

    def delete(*keys)
      if Waves.config.synchronize? 
        Waves.synchronize _delete(*keys)
      else
        _delete(*keys)
      end
    end

    def clear
      if Waves.config.synchronize? 
        Waves.synchronize _clear
      else
        _clear
      end
    end

    def fetch(key)
      if Waves.config.synchronize? 
        Waves.synchronize _fetch(key)
      else
        _fetch(key)
      end
    end 
    
    
  private
    
    def _store(key, value, ttl = {})
      @cache[key] = {
        :expires => ttl.kind_of?(Numeric) ? Time.now + ttl : nil,
        :value => value
      }
    end

    def _delete(*keys)
     keys.each {|key| @cache.delete(key) }
    end

    def _clear
      @cache.clear
    end

    def _fetch(key)
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