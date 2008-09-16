module Waves

  class Cache

    # Exception classes
    class KeyMissing < StandardError; end
    
    # Universal to all cache objects.
    def [](key)
      fetch(key)
    end

    def []=(key,value)
      store(key,value)
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
      raise KeyMissing, "#{key} doesn't exist in cache" if @cache.has_key?(key) == false
      return @cache[key][:value] if @cache[key][:expires].nil?
      
      if @cache[key][:expires] > Time.now
        @cache[key][:value]
      else
        delete key
        raise KeyMissing, "#{key} expired before access attempt"
      end
    end

    @layers = {}    
    # Class methods.
    class << self
      # Class method to keep track of layers
      def layers(layer = nil, namespace = nil)
        unless layer.nil?
          @layers[layer] = namespace
        else
          @layers
        end
      end

      # Class method to instantiate a new cache in an agnostic fashion
      def create( engine, config )
        @layers[engine].new config
      end
    end

  end
end