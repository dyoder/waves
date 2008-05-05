module Waves
  module Verify
    module Helpers
      module Request

        ::Rack::MockRequest::DEFAULT_ENV.merge!(
          'REMOTE_ADDR' => '127.0.0.1',
          'REMOTE_HOST' => 'localhost',
          'SERVER_NAME' => 'localhost',
          'SERVER_PORT' => '3000',
          'SERVER_PORT_SECURE' => '0',
          'SERVER_PROTOCOL' => 'HTTP/1.1',
          'SERVER_SOFTWARE' => 'Waves 1.0',
          'HTTP_HOST' => 'localhost',
          'HTTP_VERSION' => 'HTTP/1.1',
          'HTTP_USER_AGENT' => 'Mozilla/5.0 (Macintosh; U; Intel Mac OS X; en-US; rv:1.8.1.14) Gecko/20080404 Firefox/2.0.0.14',
          'HTTP_CACHE_CONTROL' => 'max-age=0',
          'HTTP_ACCEPT' => 'text/xml,application/xml,application/xhtml+xml,text/html;q=0.9,text/plain;q=0.8,image/png,*/*;q=0.5',
          'HTTP_ACCEPT_LANGUAGE' => 'en-us,en;q=0.5',
          'HTTP_ACCEPT_CHARSET' => 'ISO-8859-1,utf-8;q=0.7,*;q=0.7',
          'HTTP_ACCEPT_ENCODING' => 'gzip,compress;q=0.5,*;q=0.0,',
          'HTTP_CONNECTION' => 'keep-alive',
          'HTTP_KEEP_ALIVE' => '300',
          'HTTP_REFERER' => 'http://localhost/',
          'GATEWAY_INTERFACE' => 'CGI/1.1'
        )

        def request
          @request ||= ::Rack::MockRequest.new( ::Waves::Dispatchers::Default.new )
        end

        def get(uri, opts={})    request.get(uri, opts)    end
        def post(uri, opts={})   request.post(uri, opts)   end
        def put(uri, opts={})    request.put(uri, opts)    end
        def delete(uri, opts={}) request.delete(uri, opts) end

      end
    end
  end
end
