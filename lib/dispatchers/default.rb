module Waves

  module Dispatchers

    #
    # Waves::Dispatchers::Default matches requests against an application's mappings to 
    # determine what main action to take, as well as what before, after, always, and exception-handling
    # blocks must run.
    #
    # The default dispatcher also attempts to set the content type based on the
    # file extension used in the request URL. It does this using the class defined in
    # the current configuration's +mime_types+ attribute, which defaults to Mongrel's
    # MIME type handler.
    #
    # You can write your own dispatcher and use it in your application's configuration
    # file. By default, they use the default dispatcher, like this:
    #
    #   application do
    #     use Rack::ShowExceptions
    #     run Waves::Dispatchers::Default.new
    #   end
    #

    class Default < Base

      # All dispatchers using the Dispatchers::Base to provide thread-safety, logging, etc.
      # must provide a +safe+ method to handle creating a response from a request.
      # Takes a Waves::Request and returns a Waves::Reponse
      def safe( request  )

        response = request.response

        Waves.reload if Waves.debug?
        response.content_type = Waves.config.mime_types[ request.path ] || 'text/html'

        mapping = Waves.mapping[ request ]

        begin

          request.not_found if mapping[ :response ].empty?
          mapping[ :before ].each { | action | action.call( request ) }
          response.write( mapping[ :response ].first.call( request ) )
          mapping[ :after ].each { | action | action.call( request ) }
          
        rescue Exception => e

          Waves::Logger.info e.to_s
          handler = mapping[ :handle ].find { | action | action.exception === e } 
          ( handler.call( request ) if handler ) or raise e

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
