module Waves
  module Helpers
    module Model
      
			def all( model )
			  Application.models[ model ].all( domain )
      end
      
			def find( model, name )
			  Application.models[ model ].find( domain, name ) rescue nil
			end
			
		end
	end
end