module Waves

  # Defines a set of methods that simplify accessing common request and response methods.
  # These include methods not necessarily associated with the Waves::Request and Waves::Response
  # objects, but which may still be useful for constructing a response.
  #
  # This mixin assumes that a @request@ accessor already exists.
  module ResponseMixin  
    
    # Access the response.
    def response; request.response; end

    # Access the request parameters.

    # The params variable is taken from the request object and "destructured", so that
    # a parameter named 'blog.title' becomes:
    #
    #   params['blog']['title']
    #

    # If you want to access the original parameters object, you can still do so using
    # +request.params+ instead of simply +params+.
    def params; @params ||= destructure(request.params); end
    
    # Conveninent access to params specific to this resource class.
    def attributes; @attributes ||= query[model_name.singular.intern]; end
    
    # Access to params without worrying about key type. Goodbye, you indifferent hash!
    def query ; @query ||= Waves::Request::Query.new( params ) ; end

    # Returns the name of the model corresponding to this controller by taking the basename
    # of the module and converting it to snake case. If the model plurality is different than
    # the controller, this will not, in fact, be the model name.
    def model_name; self.class.basename.snake_case; end

    # Returns the model corresponding to this controller by naively assuming that 
    # +model_name+ must be correct. This allows you to write generic controller methods such as:
    #
    #   model.find( name )
    #
    # to find an instance of a given model. Again, the plurality of the controller and
    # model must be the same for this to work.
    def model; app::Models[ model_name.intern ]; end
    # Access the request session.
    def session; request.session; end
    # Access the request path.
    def path; request.path; end
    # Access the request url.
    def url; request.url; end
    # Access the request domain.
    def domain; request.domain; end
    # Issue a redirect for the given location.
    def redirect(location, status = '302'); request.redirect(location, status); end
    # Raise a "not found" exception.
    def not_found; request.not_found; end
    # Access the Waves::Logger.
    def log; Waves::Logger; end
    # Access the Blackboard
    def blackboard; request.blackboard; end
    # access stuff from an app
    def app_name ; self.class.rootname.snake_case.to_sym ; end
    def app ; eval(  "::#{app_name.to_s.camel_case}" ) ; end
    def paths( r ) ; app.paths( r ) ; end
    
    private

    def destructure( hash )
      destructured = {}
      hash.keys.map { |key| key.split('.') }.each do |keys|
        destructure_with_array_keys(hash, '', keys, destructured)
      end
      destructured
    end

    def destructure_with_array_keys( hash, prefix, keys, destructured )
      if keys.length == 1
        key = "#{prefix}#{keys.first}"
        val = hash[key]
        destructured[keys.first.intern] = case val
        when String
          val.strip
        when Hash
          val
        when nil
          raise key.inspect
        end
      else
        destructured = ( destructured[keys.first.intern] ||= {} )
        new_prefix = "#{prefix}#{keys.shift}."
        destructure_with_array_keys( hash, new_prefix, keys, destructured )
      end
    end
    
  end

end
