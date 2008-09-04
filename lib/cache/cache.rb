module Waves

  class Cache
    attr_accessor :cache

    def [](key)
      fetch(key)
    end

    def []=(key,value)
      store(key,value)
    end

    def store(key, value, ttl = {})
      @cache[key] = {
        :expires => ttl.i_a?(Number) ? Time.now + ttl : nil,
        :value => value
      }
    end

    def delete(*keys)
      keys.each {|key| @cache[key].delete }
    end

    def clear
      @cache.clear
    end

    def fetch(key)
      if @cache[key][:expires] > Time.now
        @cache[key][:value]
      else
        @cache[key][:value]
        @cachce[key].delete
      end
    end

  end
end
