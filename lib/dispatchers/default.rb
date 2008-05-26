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

        Waves::Application.instance.reload if Waves::Application.instance.debug?
        response.content_type = Waves::Application.instance.config.mime_types[ request.path ] || 'text/html'

        mapping = Waves::Application.instance.mapping[ request ]

        begin

          request.not_found unless mapping[:action]

          mapping[:before].each do | block, args |
            ResponseProxy.new(request).instance_exec(*args,&block)
          end

          block, args = mapping[:action]
          response.write( ResponseProxy.new(request).instance_exec(*args, &block) )
          
          mapping[:after].each do | block, args |
            ResponseProxy.new(request).instance_exec(*args,&block)
          end

        rescue Exception => e
          
          handler = mapping[:handlers].detect do | exception, block, args |
            e.is_a? exception
          end
          if handler
            ResponseProxy.new(request).instance_exec(*handler[2], &handler[1])
          else
            raise e
          end
          
        ensure
          mapping[:always].each do | block, args |
            begin
              ResponseProxy.new(request).instance_exec(*args,&block) 
            rescue Exception => e
              Waves::Logger.info e.to_s
            end
          end
          
        end

      end

    end

  end

end
