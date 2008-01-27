module Waves

	module Configurations

		class Base

			def self.[]=( name, val )
				meta_def("_#{name}") { val }
			end

			def self.[]( name ) ; send "_#{name}" ; end

			def self.attribute( name )
				meta_def(name) do |*args|
					raise ArgumentError.new('Too many arguments.') if args.length > 1
					args.length == 1 ? self[ name ] = args.first : self[ name ]
				end
				self[ name ] = nil
			end

			def self.mime_types
				Waves::MimeTypes
			end
			
		end
	
		class Default < Base
		  
			%w( host port ports log reloadable server database session ).
			each { |name| attribute(name) }
			
			def self.application( &block )
			  if block_given? 
  			  self['application'] = Rack::Builder.new( &block )
  			else
  			  self['application']
  			end
			end
			
			session :duration => 30.minutes, 
			  :path => :tmp / :sessions

		end
	end
end


