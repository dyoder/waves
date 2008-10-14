module Waves

  # Encapsulates the session associated with a given request. A session has an expiration
  # and path, which must be provided in a Waves::Configuration. Sensible defaults are defined
  # in Waves::Configurations::Default
  class Session
    
    # Concoct a (probably) unique session id
    def self.generate_session_id 
      # from Camping ...
      chars = [*'A'..'Z'] + [*'0'..'9'] + [*'a'..'z']
      (0..48).inject(''){|s,x| s+=chars[ rand(chars.length) ] }
    end

    # Create a new session object using the given request. This is not necessarily the
    # same as constructing a new session. The session_id cookie for the request domain
    # is used to store a session id. The actual session data will be stored in a directory
    # specified by the application's configuration file.
    def initialize( request )
      @request = request
      @data ||= ( File.exist?( session_path  ) ? load_session : {} )
    end
    
    # Return the session data as a hash
    def to_hash
      @data.to_hash
    end
    
    def self.base_path
      Waves.config.session[:path]
    end

    # Save the session data. You shouldn't typically have to call this directly, since it
    # is called by Waves::Response#finish.
    def save
      if @data && @data.length > 0
        File.write( session_path, @data.to_yaml )
        @request.response.set_cookie( 'session_id',
          :value => session_id, :path => '/',
          :expires => Time.now + Waves.config.session[:duration] )
      end
    end

    # Access a given data element of the session using the given key.
    def [](key) ; @data[key] ; end
    # Set the given data element of the session using the given key and value.
    def []=(key,val) ; @data[key] = val ; end

    private

    def session_id
      @session_id ||= ( @request.cookies['session_id'] || Waves::Session.generate_session_id )
    end

    def session_path
      Waves::Session.base_path / session_id
    end

    def load_session
      YAML.load( File.read( session_path ) )
    end

  end

end

