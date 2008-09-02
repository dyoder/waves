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
    # 1. reload any reloadable constants if Waves.debug? is true
    # 1. determine the content type using the mime-type indicated by the request URL's file extension
    # 1. identify the resource that corresponds to the request URI
    # 1. call the appropriate method on that resource
    class Default < Base

      # Takes a Waves::Request and returns a Waves::Response    
      def safe( request  )
        Waves.reload
        # set a default -- this can be overridden by the resource
        request.response.content_type = Waves.config.mime_types[ request.accepts.first ] || 'text/html'
        # grab the appropriate resource from the configuration, based on the request
        resource = Waves.config.resources[ request ]
        begin
          # invoke the request method, wrapped by the before and after methods
          resource.before
          content = resource.send( request.method )
          resource.after
        rescue Exception => e
          # handle any exceptions using the resource handlers, if any
          Waves::Logger.info e.to_s
          resource.handler( e ) rescue raise e 
        ensure
          # no matter what happens, also run the resource's always method
          resource.always
        end
        # okay, we've handled the request, now write the response unless it was already done
        request.response.write( content ) unless request.response.finished?
      end

    end

  end

end
