module Waves
  module Mocks
    
    def dispatcher ; Waves::Dispatchers::Default ; end
    def request ; Rack::MockRequest.new( dispatcher.new ) ; end
    def env( uri, opts ) ; Rack::MockRequest.env_for( uri, opts ) ; end
    def get( uri, opts = {} ) ; request.get( uri, opts ) ; end
    def put( uri, opts = {} ) ; request.put( uri, opts ) ; end
    def post( uri, opts = {} ) ; request.post( uri, opts ) ; end
    def delete( uri, opts = {} ) ; request.delete( uri, opts ) ; end
    def head( uri, opts = {} ) ; request.request( 'HEAD', uri, opts ) ; end
    
  end
end
