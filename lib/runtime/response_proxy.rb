module Waves
	
	class ResponseProxy 

    attr_reader :request

    include ResponseMixin
    
		def initialize(request); @request = request; end
		
		def use( model ) ; @model = model ; self ; end
		
		def controller( &block )
			Waves.application.controllers[ @model ].process( @request, &block )
		end
		
		def view( &block )
			Waves.application.views[ @model ].process( @request, @value, &block )
		end
		
		def |( val ); @value = val; self; end
		
		def to_s; @value ; end
		
		def redirect(path, status = '302'); @request.redirect(path, status); end
		
	end
	
end