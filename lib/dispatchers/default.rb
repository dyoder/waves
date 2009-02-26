module Waves

  module Dispatchers

    class Default < Base

      # Takes a Waves::Request and returns a Waves::Response
      def safe( request  )
        # set a default content type -- this can be overridden by the resource
        request.response.content_type = request.ext || 'text/html'
        resource = Waves.config.resource.new( request )
        if request.response.body.empty?
          request.response.write resource.process.to_s
        else
          resource.process
        end
        # okay, we've handled the request, now write the response unless it was already done
        request.response.finish
      end

    end

  end

end
