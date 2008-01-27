module Waves
	
	module Dispatchers
	
		class Default < Base
		
			def safe( request  )
			  
				response = request.response
			
				Waves::Server.reset if Waves::Server.debug?
				response.content_type = Waves::Server.config.mime_types[ request.path ] || 'text/html'

				mapping = Waves::Server.mapping[ request ]

				mapping[:before].each do | block, args |
				  ResponseProxy.new(request).instance_exec(*args,&block)
				end
				
				block, args = mapping[:action]
				response.write( ResponseProxy.new(request).instance_exec(*args, &block) )

				mapping[:after].each do | block, args |
				  ResponseProxy.new(request).instance_exec(*args,&block)
				end
									
			end
			
		end
		
	end
		
end
