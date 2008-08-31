module Waves
  module Utilities # :nodoc:
    
    # Utility methods mixed into Hash.
    module Hash
      
      # Return a copy of the hash where all keys have been converted to strings.
      def stringify_keys
        inject({}) do |options, (key, value)|
          options[key.to_s] = value
          options
        end
      end

      # Destructively convert all keys to symbols.
      def symbolize_keys!
        keys.each do |key|
          unless key.is_a?(Symbol)
            self[key.to_sym] = self[key]
            delete(key)
          end
        end
        self
      end
    end
  end
end

class Hash # :nodoc:
  include Waves::Utilities::Hash
end