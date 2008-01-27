module Waves

	module Dispatchers

	  class NotFoundError < Exception ; end
		
		class Redirect < Exception 
			attr_reader :path
			def initialize( path )
				@path = path
			end
		end
		
		class Base
				
			def call( env )
			  Waves::Server.synchronize do
  				request = Waves::Request.new( env )
  				response = request.response
  				begin
  					safe( request )
  				rescue Dispatchers::Redirect => redirect
  					response.status = '302'
  					response.location = redirect.path
  				rescue Dispatchers::NotFoundError => e
  					html = Waves.application.views[:errors].process( request ) do
  				    not_found_404( :error => e ) 
  				  end
  					response.status = '404'
  					response.content_type = 'text/html'
  					response.write( html )
  				end
  				response.finish
  			end
			end
			
		end

	end	
	
end