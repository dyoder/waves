module Waves
  module Helpers
    module View
      
			def view( model, view, assigns = {} )
        self << Application.views[ model ].process( request ) do
	        send view, assigns
	      end
			end
			
			
		end
	end
end