module Waves

  # Defines a set of methods that simplify accessing common request and response methods.
  # These include methods not necessarily associated with the Waves::Request and Waves::Response
  # objects, but which may still be useful for constructing a response.
  #
  # This mixin assumes that a @request@ accessor already exists.
  module ResponseMixin  
    
    # Access the response.
    def response; request.response; end

    # Access to the query string as a object where the keys are accessors
    # You can still access the original query as request.query
    def query ; @query ||= Waves::Request::Query.new( request.query ) ; end    
    
    # Elements captured the path
    def captured ; @captured ||= request.traits.waves.captured ; end
    
    # Both the query and capture merged together
    def params ; @params ||= query.merge( captured ) ; end
    
    def paths( rname = nil ) ; debugger; request.traits.waves.resource.paths( rname) ; end
    
    %w( session path url domain not_found blackboard ).each do | m |
      define_method( m ) { request.send( m ) }
    end
    
    # Issue a redirect for the given location.
    def redirect(location, status = '302'); request.redirect(location, status); end
    # Access the Waves::Logger.
    def log; Waves::Logger; end
    # access stuff from an app
    def app_name ; self.class.rootname.snake_case.to_sym ; end
    def app ; eval(  "::#{app_name.to_s.camel_case}" ) ; end    
    
  end

end
