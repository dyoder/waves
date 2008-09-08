module Waves

  module Layers

    module Cache

      class FileCache < Waves::Cache

        def initialize(dir)
          @directory = dir
          @cache = {}
        end

        def store(key, value, ttl = {})
          super(key, value, ttl)

          key_file = @directory / key

          file = File.new(key_file,'w')
          Marshal.dump(@cache[key], file)
          file.close
        end

        def delete(*keys)
          keys.each {|key| File.delete(@directory / key) }
          super *keys
        end

        def clear
          @cache.each_key {|key| File.delete(@directory / key) }
          super
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

    end

  end

end