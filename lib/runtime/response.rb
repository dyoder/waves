module Waves
	class Response
		
		attr_reader :request
		
		def initialize( request )
			@request = request
			@response = Rack::Response.new
		end
				
		%w( Content-Type Content-Length Location Expires ).each do |header|
			define_method( header.downcase.gsub('-','_')+ '=' ) do | val |
				@response.headers[header] = val
			end
		end
				
		def session ; request.session ; end
		
		def finish ; request.session.save ; @response.finish ; end
				
		def method_missing(name,*args)
			@response.send(name,*args)
		end
		
	end
end
