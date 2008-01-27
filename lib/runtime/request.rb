module Waves
	class Request
		
		class ParseError < Exception ; end
		
		attr_reader :response, :session
		
		def initialize( env ) # Rack::Request
			@request = Rack::Request.new( env )
			@response = Waves::Response.new( self )
			@session = Waves::Session.new( self )
		end
				
		# if we haven't overridden it, give it to Rack
		def method_missing(name,*args)
			@request.send(name,*args)
		end
		
		# TODO: should / does this exclude the query_string?
		# Is there a Rack API that is more appropos
		def path
			@request.path_info
		end
		
    def domain
      @request.host
    end
    
		def method
			@request.request_method.downcase.intern
		end	
		
		def not_found
  		raise Waves::Dispatchers::NotFoundError.new( @request.url + ' not found.')
  	end

		def redirect( path )
			raise Waves::Dispatchers::Redirect.new( path )
		end
		
	end
	
end