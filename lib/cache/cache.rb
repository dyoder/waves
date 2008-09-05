module Waves

  class Cache
    attr_accessor :cache

    def initialize
      @cache = {}
    end

    def [](key)
      fetch(key)
    end

    def []=(key,value)
      store(key,value)
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
      return @cache[key][:value] if @cache[key][:expires].nil?
      
      if @cache[key][:expires] <= Time.now
        @cache[key][:value]
        delete key
      else
        @cache[key][:value]
      end
    end

  end
end