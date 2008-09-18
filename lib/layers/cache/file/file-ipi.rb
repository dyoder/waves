module Waves
  module Cache

    class File < Waves::Cache::IPI

      def initialize(arg)
        raise ArgumentError, ":dir needs to not be nil" if arg[:dir].nil?
        @directory = arg[:dir]
        @cache = {}
      end

      def store(key, value, ttl = {})
        Waves.synchronize do

          super(key, value, ttl)
          @keys << key

          key_file = @directory / key

          file = File.new(key_file,'w')
          Marshal.dump(@cache[key], file)
          file.close
          @cache.delete key

        end
      end

      def delete(*keys)
        Waves.synchronize do

          keys.each do |key|
            if @keys.include? key
              File.delete(@directory / key)
              @keys.delete key
            else
              raise KeyMissing, "no key #{key} to delete"
            end
          end

        end
      end

      def clear
        Waves.synchronize do

          @keys.each {|key| File.delete(@directory / key) }
          @keys.clear

        end
      end

      def fetch(key)
        Waves.synchronize do

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


