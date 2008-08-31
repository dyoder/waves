module Waves
  module Utilities
    
    # Utility methods mixed into String.
        
    module String
      
      # Syntactic sugar for using File.join to concatenate the argument to the receiver.
      #
      #   require "lib" / "utilities" / "string"
      #
      # The idea is not original, but we can't remember where we first saw it.
      # 
      # Waves::Utilities::Symbol defines the same method, allowing for :files / 'afilename.txt'
      
      def / ( string )
        File.join(self,string.to_s)
      end
      
      # produces stringsLikeThis
      def lower_camel_case
        gsub(/(_)(\w)/) { $2.upcase }
      end

      # produces StringsLikeThis
      def camel_case
        lower_camel_case.gsub(/^([a-z])/) { $1.upcase }
      end

      # produces strings_like_this
      def snake_case
        gsub(/\s+/,'').gsub(/([a-z\d])([A-Z])/){ "#{$1}_#{$2}"}.tr("-", "_").downcase
      end

      def title_case
        gsub(/(^|\s)\s*([a-z])/) { $1 + $2.upcase }
      end

      def text
        gsub(/[\_\-\.\:]/,' ')
      end
      
    end
  end
end

class ::String # :nodoc:
  include Waves::Utilities::String
end
