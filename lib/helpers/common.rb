module Waves
  module Helpers
    module Common
      
      def layout( name, assigns = {}, &block )
				assigns[ :content ] = yield
				Blog::Views::Layouts.process( request ) do 
					send( name, assigns )
				end
			end
			
			def doctype(type)
				case type
				when :html4_strict
					'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" ' <<
						'"http://www.w3.org/TR/html4/strict.dtd">'
				end
			end
			
		end
	end
end