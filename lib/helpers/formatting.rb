require 'redcloth'
module Waves
  module Helpers
    module Formatting

      # TODO: this won't work inside a erb template!
      # but i hate to do a whole new Builder when I'm
      # already inside one! test self === Builder? 
      def mab( content )
        eval content
      end

      def textile( content )
      	( ::RedCloth::TEXTILE_TAGS  << [ 96.chr, '&8216;'] ).each do |pat,ent|
      		content.gsub!( pat, ent.gsub('&','&#') )
      	end
      	::RedCloth.new( content ).to_html
      end

		end
	end
end