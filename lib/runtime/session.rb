module Waves
	class Session
		
		def initialize( request )
			@request = request
			@data ||= ( File.exist?( session_path  ) ? load_session : {} )
		end
		
		def save
			if @data && @data.length > 0
				File.write( session_path, @data.to_yaml )
				@request.response.set_cookie( 'session_id', 
					:value => session_id, :path => '/', 
					:expires => Time.now + Waves::Server.config.session[:duration] )
			end
		end
		
		def [](key) ; @data[key] ; end
		def []=(key,val) ; @data[key] = val ; end
		
		private
		
		def session_id
			@request.cookies['session_id'] || generate_session_id 
		end
		
		def generate_session_id # from Camping ...
			chars = [*'A'..'Z'] + [*'0'..'9'] + [*'a'..'z']
			(0..48).inject(''){|s,x| s+=chars[ rand(chars.length) ] }
		end
		
		def session_path
		  Waves::Server.config.session[:path] / session_id
		end
		
		def load_session
			YAML.load( File.read( session_path ) )
		end
		
	end
	
end
		