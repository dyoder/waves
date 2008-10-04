module Waves

  # A Dispatcher in Waves is the interface between the outside world and the Waves application code.  
  # Dispatchers that inherit from Waves::Dispatchers::Base are "Rack applications", to use the 
  # terminology of the Rack specification.
  # 
  # Rack turns an incoming HTTP request into a environment hash and passes it as an argument to 
  # the Dispatcher's +call+ method.  The dispatcher must return an array containing the status code, 
  # response headers, and response body.  Waves::Dispatchers::Base provides a basic structure so that
  # subclassed dispatchers need only implement the +safe+ method, which operates on a Waves::Request
  # and returns a Waves::Response.  The +call+ method implemented by the Base dispatcher formats the 
  # return value required by the Rack specification.
  # 
  # You can write your own dispatcher and use it in the Rack::Builder block in your configuration
  # files. By default, the configurations use the Default dispatcher:
  #
  #   application do
  #     use Rack::ShowExceptions
  #     run Waves::Dispatchers::Default.new
  #   end
  #
  module Dispatchers

    #
    # Waves::Dispatchers::Default processes a Waves::Request and returns a Waves::Response as follows:
    #

    class Default < Base

      # Takes a Waves::Request and returns a Waves::Response    
      def safe( request  )
        Waves.reload
        # set a default content type -- this can be overridden by the resource
        request.response.content_type = request.accept.default
        # grab the appropriate resource from those declared in the configuration, based on the request
        resource = Waves.config.resource.new( request )
        resource.process
        # okay, we've handled the request, now write the response unless it was already done
        request.response.finish
      end

    end

  end

end
