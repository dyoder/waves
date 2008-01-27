module Waves
  
  module ResponseMixin
    
    # assumes request method
    
    def response
      request.response
    end
    
    def params
			request.params
		end
		
		def session
			request.session
		end
		
		def path
		  request.path
		end
		
		def url
		  request.url
		end
		
		def domain
		  request.domain
		end
		
		def redirect(location)
		  request.redirect(location)
		end
		
		def models
		  Waves.application.models
		end
		
		def views
		  Waves.application.views
		end
		
		def controllers
		  Waves.application.controllers
		end
		
		def not_found
		  request.not_found
		end
		
	end
	
end