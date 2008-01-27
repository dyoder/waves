module Waves
	
	module Views

		class NoTemplateError < Exception ; end
	
		def Views.renderers
			return [] if Renderers.constants.nil?
			Renderers.constants.inject([]) do |rx,cname|
				( Module === (c=Renderers.const_get(cname)) &&
					c < Renderers::Mixin ) ? ( rx << c ) : rx
			end
		end

	
		module Mixin
				
			attr_reader :request
			
			include Waves::ResponseMixin
			
			def self.included( c )
				def c.process( request, *args, &block )
					self.new( request ).instance_exec( *args, &block )
				end
			end
			
			def initialize( request )
				@request = request
				@layout = :default
			end
			
			def renderer(path)
				Views.renderers.find do |renderer| 
					File.exists?( renderer.filename( path ) )
				end
			end
			
			def render( path, context = {} )
				context.merge!( :request => request ) 
				template = renderer( path ) || renderer( :generic / File.basename(path) )
				raise NoTemplateError.new( path ) if template.nil?
				template.render( path, context )
			end
			
			def method_missing(name,*args)
				render( "/#{self.class.basename.snake_case}/#{name}", *args )
			end
			
		end

	end

end
