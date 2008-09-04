module Waves

  module Layers

    class FileCache < Waves::Cache

      @files = Hash.new

      def store(key, value, ttl = {})
        item = {
          :expires => ttl.i_a?(Number) ? Time.now + ttl : nil,
          :value => value
        }

        @files[key] = File.new(key,'w') if @files[key].nil?
        Marshal.dump(item, @file[key])
      end

      def delete(*keys)
        keys.each do |key|
          File.delete(@files[key])
          @files[key].delete
        end
      end

      def clear
        # in a sec...
      end

      def fetch(key)
        raise "No cache found for #{key}" unless @files[key]
        item = Marshal.load(@files[key])

        if item[:expires] > Time.now
          item[:value]
        else
          File.delete(@files[key])
          @files[key].delete
          item[:value]
        end
      end

    end

  end

end