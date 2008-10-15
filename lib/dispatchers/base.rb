module Waves

  module Dispatchers

    # A NotFoundError means what you think it means.  The dispatchers included with Waves do not
    # natively intercept this exception.  Instead an exception handler must be registered in the application
    # mappings.  The Simple foundation registers a minimal handler, while the Default foundation registers
    # a slightly fleshier one.
    class NotFoundError < RuntimeError ; end
    class Unauthorized < RuntimeError; end
    class BadRequest < RuntimeError; end

    # Redirect exceptions are rescued by the Waves dispatcher and used to set the 
    # response status and location.
    class Redirect < Exception
      attr_reader :path, :status
      def initialize( path, status = '302' )
        @path = path
        @status = status
      end
      def message
        "location: #{@path} status: #{@status}"
      end
    end

    # Waves::Dispatchers::Base provides the basic request processing structure for a Rack application.
    # It creates a Waves request, determines whether to enclose the request processing in a mutex
    # benchmarks it, logs it, and handles redirects. Derived classes need only 
    # process the request within the +safe+ method, which must take a Waves::Request and return a Waves::Response.

    class Base

      # As with any Rack application, a Waves dispatcher must provide a call method
      # that takes an +env+ hash.
      def call( env )
        response = if Waves.synchronize? or Waves.debug?
          Waves.synchronize { Waves.reload ; _call( env )  }
        else
          _call( env )
        end
      end

      # Called by event driven servers like thin and ebb. Returns true if
      # the server should run the request in a separate thread, as determined by
      # Configurations::Mapping#threaded?
      def deferred?( env )
        # TODO: impl.
      end
      
      private
      
      def _call( env )
        request = Waves::Request.new( env )
        response = request.response
        t = Benchmark.realtime do
          begin
            safe( request )
          rescue Dispatchers::Redirect => redirect
            response.status = redirect.status
            response.location = redirect.path
          rescue Dispatchers::Unauthorized
            response.status = 401
            response['WWW-Authenticate'] = "Basic realm=Waves"
          rescue Dispatchers::BadRequest
            response.status = 400
          end
        end
        Waves::Logger.info "#{request.method}: #{request.url} handled in #{(t*1000).round} ms."
        response.finish
      end

    end

  end

end
