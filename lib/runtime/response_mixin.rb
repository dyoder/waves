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
    def mapping; Waves.application.mapping ; end
    def redirect(location, status = '302'); request.redirect(location, status); end
    # Access the primary application's models
    def models; Waves.application.models; end
    # Access the primary application's views
    def views; Waves.application.views; end
    # Access the primary application's controllers
    def controllers; Waves.application.controllers; end
    # Raise a "not found" exception.
    def not_found; request.not_found; end
    # Access the Waves::Logger.
    def log; Waves::Logger; end
    # Access the Blackboard
    def blackboard; request.blackboard; end

  end

end
