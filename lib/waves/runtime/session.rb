module Waves

  # Encapsulates the session associated with a given request. A session has an expiration
  # and path, which must be provided in a Waves::Configuration. Sensible defaults are defined
  # in Waves::Configurations::Default

  class Session

    # Create a new session object using the given request. This is not necessarily the
    # same as constructing a new session. See Rack::Sesssion for more info.
    def initialize(request)
      @data = request.rack_request.env['rack.session']
    end

    # Return the session data as a hash
    def to_hash()
      @data
    end

    # Access a given data element of the session using the given key.
    def [](key)
      @data[key]
    end

    # Set the given data element of the session using the given key and value.
    def []=(key, val)
      @data[key] = val
    end
    
    # invalidate the whole session
    def clear ; @data.clear ; end

  end

end

