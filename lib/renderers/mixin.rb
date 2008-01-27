module Waves
	
	module Renderers
		
		extend Autoload
		autoload :renderers
	
		module Mixin
		
			def self.included(target)
				class << target
					
					def extension(*args)
						return @extension if args.length == 0
						@extension = args.first
					end
					
					def filename(path)
						:templates / "#{path}.#{self.extension}"
					end
					
					def render(path,args=nil)
					end
					
					def template( path )
						File.read( filename( path ) )
					end
					
					def helper( path )
						Waves.application.helpers[ 
						  File.basename( File.dirname( path ) ).camel_case ]
					end
				end
			end

				
		end

	end

end