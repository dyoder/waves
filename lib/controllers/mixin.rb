module Waves

	module Controllers

		module Mixin
		
			attr_reader :request
			
			include Waves::ResponseMixin

			def self.included( c )
				def c.process( request, &block )
					self.new( request ).instance_eval( &block )
				end
			end
				
			def initialize( request )
				@request = request
			end
			
			
			# override to convert 'foo.bar' to 'foo' => 'bar' => value
			def params
				@params ||= destructure(request.params)
			end

			def model_name
				self.class.basename.snake_case
			end
		
			def model
				Waves.application.models[ model_name.intern ]
			end
			
			private
			
			def destructure(hash)
				rval = {}
				hash.keys.map{ |key|key.split('.') }.each do |keys|
					destructure_with_array_keys(hash,'',keys,rval)
				end
				rval
			end
			
			def destructure_with_array_keys(hash,prefix,keys,rval)
				if keys.length == 1
					val = hash[prefix+keys.first]
					rval[keys.first.intern] = case val
				  when String then val.strip
			    when Hash then val
			    end
				else
					rval = ( rval[keys.first.intern] ||= {} )
					destructure_with_array_keys(hash,(keys.shift<<'.'),keys,rval)
				end
			end
										
		end
	
	end

end