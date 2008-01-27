module Waves
	
	module Helpers
		
		module Form
			
			def properties(&block)
			  div.properties do
			    yield
			  end
			end
			
			def property( options )
			  self << view( :form, options[:type], options )
			end
			
			
		end
		
	end
	
end