module Waves
  # Waves::Request represents an HTTP request and has methods for accessing anything
  # relating to the request. See Rack::Request for more information, since many methods
  # are actually delegated to Rack::Request.
	class Request
		
		class ParseError < Exception ; end
		
		attr_reader :response, :session
		
		# Create a new request. Takes a env parameter representing the request passed in from Rack.
		# You shouldn't need to call this directly.
		def initialize( env )
			@request = Rack::Request.new( env )
			@response = Waves::Response.new( self )
			@session = Waves::Session.new( self )
		end
				
		# Accessor not explicitly defined by Waves::Request are delegated to Rack::Request. 
		# Check the Rack documentation for more information.
		def method_missing(name,*args)
			@request.send(name,*args)
		end
		
		# The request path (PATH_INFO). Ex: +/entry/2008-01-17+
		def path
			@request.path_info
		end

		# The request domain. Ex: +www.fubar.com+
    def domain
      @request.host
    end
    
    # The request method: GET, PUT, POST, or DELETE.
		def method
			@request.request_method.downcase.intern
		end	
		
		# Raise a not found exception.
		def not_found
  		raise Waves::Dispatchers::NotFoundError.new( @request.url + ' not found.')
  	end

    # Issue a redirect for the given path.
		def redirect( path )
			raise Waves::Dispatchers::Redirect.new( path )
		end
		
	end
	
end