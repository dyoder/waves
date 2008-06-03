module Waves
  # Waves::Response represents an HTTP response and has methods for constructing a response.
  # These include setters for +content_type+, +content_length+, +location+, and +expires+
  # headers. You may also set the headers directly using the [] operator. If you don't find
  # what you are looking for here, check the documentation for Rack::Response since many
  # methods for this class are delegated to Rack::Response.
  class Response

    attr_reader :request

    # Create a new response. Takes the request object. You shouldn't need to call this directly.
    def initialize( request )
      @request = request
      @response = Rack::Response.new
    end
    
    def rack_response; @response; end

    %w( Content-Type Content-Length Location Expires ).each do |header|
      define_method( header.downcase.gsub('-','_')+ '=' ) do | val |
        @response[header] = val
      end
    end

    # Returns the sessions associated with the request, allowing you to set values within it.
    # The session will be created if necessary and saved when the response is complete.
    def session ; request.session ; end

    # Finish the response. This will send the response back to the client, so you shouldn't
    # attempt to further modify the response once this method is called. You don't usually
    # need to call it yourself, since it is called by the dispatcher once request processing
    # is finished.
    def finish ; request.session.save ; @response.finish ; end

    # Methods not explicitly defined by Waves::Response are delegated to Rack::Response.
    # Check the Rack documentation for more informations
    def method_missing(name,*args)
      @response.send(name,*args)
    end

  end
end
