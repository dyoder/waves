module Waves
  module Verify
    module Helpers
      module Request
      
        def request
          @request ||= ::Rack::MockRequest.new( ::Waves::Dispatchers::Default.new )
        end

        [:get,:put,:post,:delete].each do |method|
          define_method method do | path |
            request.send( method, path )
          end
        end
      
      end
    end
  end
end