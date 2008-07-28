module Waves

  # Defines a set of methods that simplify accessing common request and response methods.
  # These include methods not necessarily associated with the Waves::Request and Waves::Response
  # objects, but which may still be useful for constructing a response.
  #
  # This mixin assumes that a @request@ accessor already exists.
  module ResponseMixin  
    include Functor::Method  
    # Access the response.
    def response; request.response; end
    # Access the request parameters.
    def params; request.params; end
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
    def app_name ; self.name.split('::').first.snake_case.to_sym ; end
    
    lambda {
      string_or_symbol = lambda { |arg| arg.kind_of?(String) || arg.kind_of?(Symbol) }
      functor( :app ) { app( app_name ) }
      functor( :app, string_or_symbol ) { |name| Waves.applications[ name ] }
      functor( :resources ) { app[ :resources ] }
      functor( :resources, string_or_symbol ) { |name| app( name )[ :resources ] }
      functor( :paths, string_or_symbol ) { |rname| resources[ rname ].paths }
      functor( :paths, string_or_symbol, string_or_symbol ) { |aname, rname| resources( aname )[ rname ].paths }
    }.call

  end

end
