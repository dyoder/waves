module Waves
  # Waves::Request represents an HTTP request and has methods for accessing anything
  # relating to the request. See Rack::Request for more information, since many methods
  # are actually delegated to Rack::Request.
  class Request

    class ParseError < Exception ; end

    attr_reader :response, :session, :blackboard

    # Create a new request. Takes a env parameter representing the request passed in from Rack.
    # You shouldn't need to call this directly.
    def initialize( env )
      @request = Rack::Request.new( env )
      @response = Waves::Response.new( self )
      @session = Waves::Session.new( self )
      @blackboard = Waves::Blackboard.new( self )
    end
    
    def rack_request; @request; end

    # Accessor not explicitly defined by Waves::Request are delegated to Rack::Request.
    # Check the Rack documentation for more information.
    def method_missing(name,*args)
      @request.send(name,*args)
    end

    # The request path (PATH_INFO). Ex: +/entry/2008-01-17+
    def path
      @request.path_info
    end

    # The request domain. Ex: +www.fubar.com+
    def domain
      @request.host
    end

    # The request content type.
    def content_type
      @request.env['CONTENT_TYPE']
    end

    # Supported request methods
    METHODS = %w{get post put delete head options trace}

    # Override the Rack methods for querying the request method.
    METHODS.each do |method|
      class_eval "def #{method}?; method == :#{method} end"
    end

    # The request method. Because browsers can't send PUT or DELETE
    # requests this can be simulated by sending a POST with a hidden
    # field named '_method' and a value with 'PUT' or 'DELETE'. Also
    # accepted is when a query parameter named '_method' is provided.
    def method
      @method ||= begin
        request_method = @request.request_method.downcase
        if request_method == 'post'
          _method = @request['_method']
          _method.downcase! if _method
          METHODS.include?(_method) ? _method.intern : :post
        else
          request_method.intern
        end
      end
    end

    # Raise a not found exception.
    def not_found
      raise Waves::Dispatchers::NotFoundError.new( @request.url + ' not found.' )
    end

    # Issue a redirect for the given path.
    def redirect( path, status = '302' )
      raise Waves::Dispatchers::Redirect.new( path, status )
    end

  end

end
