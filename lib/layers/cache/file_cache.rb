module Waves
  module Layers
    module Cache

      class FileCache < Waves::Cache

        def initialize(arg)
          raise ArgumentError, ":dir needs to not be nil" if arg[:dir].nil?
          @directory = arg[:dir]
          @cache = {}
          @keys = []  # for keeping track of the files we've created without keeping
        end

        def store(key, value, ttl = {})
          super(key, value, ttl)
          @keys << key

          key_file = @directory / key

          file = File.new(key_file,'w')
          Marshal.dump(@cache[key], file)
          file.close
          @cache.delete key
        end

        def delete(*keys)
          keys.each {|key| File.delete(@directory / key); @keys.delete key }
          #super *keys
        end

        def clear
          @keys.each {|key| File.delete(@directory / key) }
          @keys.clear
        end

        def fetch(key)
          raise WavesCacheError::KeyMissing, "#{key} doesn't exist" unless File.exists?(@directory / key)
          @cache[key] = Marshal.load File.new(@directory / key)
          return @cache[key][:value] if @cache[key][:expires].nil?

          if @cache[key][:expires] > Time.now
            @cache[key][:value]
          else
            delete key
            raise WavesCacheError::KeyMissing, "#{key} expired before access attempt"
          end
        end

      end

      def self.included(app)
        Waves.cache = Waves::Layers::Cache::FileCache.new( Waves.config.cache )
      end
      
    end
  end
end