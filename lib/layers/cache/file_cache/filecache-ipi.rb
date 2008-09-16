module Waves
  module Layers
    module Cache

      module FileCache
        class IPI < Waves::Cache
        # IPI stands for 'Implemented Programming Interface'
        

          def initialize(arg)
            raise ArgumentError, ":dir needs to not be nil" if arg[:dir].nil?
            @directory = arg[:dir]
            @cache = {}
            @keys = []  # for keeping track of the files we've created without keeping
          end

    
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
            super(key, value, ttl)
            @keys << key

            key_file = @directory / key

            file = File.new(key_file,'w')
            Marshal.dump(@cache[key], file)
            file.close
            @cache.delete key
          end

          def _delete(*keys)
            keys.each do |key|
              if @keys.include? key
                File.delete(@directory / key)
                @keys.delete key
              else
                raise KeyMissing, "no key #{key} to delete"
              end
            end
          end

          def _clear
            @keys.each {|key| File.delete(@directory / key) }
            @keys.clear
          end

          def _fetch(key)
            raise KeyMissing, "#{key} doesn't exist" unless File.exists?(@directory / key)
            @cache[key] = Marshal.load File.new(@directory / key)
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
  end
end


