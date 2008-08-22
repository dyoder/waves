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
    # 1. evaluate all :before mappings that match the request
    # 1. evaluate the first :action mapping that matches the request.  If nothing matches, raise a NotFoundError
    # 1. evalute all :after mappings that match the request
    # 1. if any exceptions were raised, evaluate the first 
    #    exception handler that matches the request.  If no handlers match the request, re-raise the exception.
    # 1. evaluate every :always mapping that matches the request.  Log any exceptions and continues.

    class Default < Base

      # Takes a Waves::Request and returns a Waves::Response    
      def safe( request  )

        response = request.response

        Waves.reload if Waves.debug?
        response.content_type = Waves.config.mime_types[ request.path ] || 'text/html'

        mapping = Waves.mapping[ request ]

        begin

          request.not_found if mapping[ :main ].empty?
          mapping[ :before ].each { | action | action.call( request ) }
          response.write( mapping[ :main ].first.call( request ) )
          mapping[ :after ].each { | action | action.call( request ) }
          
        rescue Exception => e

          Waves::Logger.info e.to_s
          handler = mapping[ :handle ].find { | action | action.exception === e } 
          ( handler.call( request, e ) if handler ) or raise e

        ensure

          mapping[ :always ].each do | action |
            begin
              action.call( request ) 
            rescue Exception => e
              Waves::Logger.info e.to_s
            end
          end
          
        end

      end

    end

  end

end
