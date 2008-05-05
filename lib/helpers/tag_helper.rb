module Waves
  module Helpers
    module TagHelper
      
      ESCAPE_TABLE = { '&'=>'&amp;', '<'=>'&lt;', '>'=>'&gt;', '"'=>'&quot;', "'"=>'&#039;', }
      def h(value)
        value.to_s.gsub(/[&<>"]/) { |s| ESCAPE_TABLE[s] }
      end
      
      
      # Returns the escaped +html+ without affecting existing escaped entities.
      #
      #   escape_once("1 > 2 &amp; 3")
      #    # => "1 &lt; 2 &amp; 3"
      def escape_once(html)
        fix_double_escape(h(html.to_s))
      end
      
      private
        
        def tag_options(options)
          cleaned_options = convert_booleans(options.stringify_keys.reject {|key, value| value.nil?})
          ' ' + cleaned_options.map {|key, value| %(#{key}="#{escape_once(value)}")}.sort * ' ' unless cleaned_options.empty?
        end
        
        def convert_booleans(options)
          %w( disabled readonly multiple ).each { |a| boolean_attribute(options, a) }
          options
        end
        
        def boolean_attribute(options, attribute)
          options[attribute] ? options[attribute] = attribute : options.delete(attribute)
        end
        
        # Fix double-escaped entities, such as &amp;amp;, &amp;#123;, etc.
        def fix_double_escape(escaped)
          escaped.gsub(/&amp;([a-z]+|(#\d+));/i) { "&#{$1};" }
        end
        
    end
  end
end