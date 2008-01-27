module Waves

	module Mapping
		
		def before( pattern, options=nil, &block )
			filters[:before] << [ pattern, options, block ]
		end
		
		def after( pattern, options=nil, &block )
			filters[:after] << [ pattern, options, block ]
		end
		
		def wrap( pattern, options=nil, &block )
			filters[:before] << [ pattern, options, block ]
			filters[:after] << [ pattern, options, block ]
		end		

		def map( options, &block )
			pattern = options[:path] || options[:url]
			mapping << [ pattern, options, block ]
		end
		
		def path( pat, options = {}, &block )
			options[:path] = pat; map( options, &block )
		end
		
		def url( pat, options = {}, &block )
			options[:url] = pat; map( options, block )
		end
		
		def []( request )

			rx = { :before => [], :after => [], :action => nil }
			
			( filters[:before] + filters[:wrap] ).each do | pattern, options, function |
				matches = pattern.match(request.path)
				rx[:before] << [ function, matches[1..-1] ] if matches &&
					( ! options || satisfy( request, options ))
			end
			
			mapping.find do |pattern, options, function|
				matches = pattern.match(request.path)
				rx[:action] = [ function, matches[1..-1] ] if matches && 
					( ! options || satisfy( request, options ) )
			end
			
			( filters[:after] + filters[:wrap] ).each do | pattern, options, function |
				matches = pattern.match(request.path)
				rx[:after] << [ function, matches[1..-1] ] if matches &&
					( ! options || satisfy( request, options ))
			end
			
			not_found(request) unless rx[:action]
			
			return rx
				
		end		
				
		private
		
		def mapping; @mapping ||= []; end
		
		def filters; @filters ||= { :before => [], :after => [], :wrap => [] }; end

		def not_found(request)
			raise Waves::Dispatchers::NotFoundError.new( request.url + ' not found.')
		end
		
		def satisfy( request, options )
			options.each do |method, param|
				return false unless self.send( method, param, request )
			end
			return true
		end
		
		def method( method, request )
			request.method == method
		end

	end

end
