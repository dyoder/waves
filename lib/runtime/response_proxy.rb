module Waves
	
	class ResponseProxy 

    attr_reader :request

    include ResponseMixin
    
		def initialize(request); @request = request; end
		
		# 
		# def use( model ) ; @model = model ; self ; end
		# 
		# def controller( &block )
		# 	Waves.application.controllers[ @model ].process( @request, &block )
		# end
		# 
		# def view( &block )
		# 	Waves.application.views[ @model ].process( @request, @value, &block )
		# end
		# 
		# def |( val ); @value = val; self; end
		# 
		
		def resource( resource = nil, &block )
		  @resource = resource
		  @response = yield if block_given?
		  return self
	  end
	  
		def controller( &block )
			lambda { Waves.application.controllers[ @resource ].process( @request, &block ) }
		end
	  
		def view( &block )
			lambda { |val| Waves.application.views[ @resource ].process( @request, val, &block ) }
		end
		
		def to_s
		  case @response
	    when String then @response
      when Proc then @response.call.to_s
      else @response.to_s
      end
		end
		
		def redirect(path, status = '302'); @request.redirect(path, status); end
		
	end
	
end