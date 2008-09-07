module Waves

  class Cache
    attr_accessor :cache

    # Universal to all cache objects.
    def [](key)
      fetch(key)
    end

    def []=(key,value)
      store(key,value)
    end
 
    def exists?(key)
      fetch(key) == nil ? false : true
    end

    alias_method :exist?, :exists?

    # Replace these when you write a layer.
    def initialize
      @cache = {}
    end
    
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

    def fetch(key)
      return nil if @cache[key].nil?
      return @cache[key][:value] if @cache[key][:expires].nil?
      
      if @cache[key][:expires] > Time.now
        @cache[key][:value]
      else
        delete key
        return nil
      end
    end

  end
end