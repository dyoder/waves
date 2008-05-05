require 'redcloth'
module Waves
  module Helpers
    
    # Formatting helpers are used to convert specialized content, like Markaby or 
    # Textile, into valid HTML. It also provides common escaping functions.
    module Formatting
      
      # Escape a string as HTML content.
      def escape_html(s); Rack::Utils.escape_html(s); end
      
      # Escape a URI, converting quotes and spaces and so on.
      def escape_uri(s); Rack::Utils.escape(s); end
      
      # Treat content as Markaby and evaluate (only works within a Markaby template).
      # Used to pull Markaby content from a file or database into a Markaby template.
      def markaby( content ); self << eval( content ); end

      # Treat content as Textile.
      def textile( content )
        return if content.nil? or content.empty?
        ( ::RedCloth::TEXTILE_TAGS  << [ 96.chr, '&8216;'] ).each do |pat,ent|
          content.gsub!( pat, ent.gsub('&','&#') )
        end
        self << ::RedCloth.new( content ).to_html
      end

    end
  end
end