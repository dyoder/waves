module Waves

  module Dispatchers

    class Default < Base

      def call(env)
        request = Waves::Request.new env
        response = request.response

        begin
          response.content_type = request.accept.default
          resource = Waves.config.resource.new request

#          resource.before

          response.write resource.send(request.method, request)

#          resource.after

        rescue Waves::Dispatchers::Redirect => redirect
          response.status = redirect.status
          response.location = redirect.path

        rescue Exception => error
          Waves::Logger.warn error.to_s
          error.backtrace.each {|frame| Waves::Logger.debug "    #{frame}" }

          response.status = 500
          response.write resource.handler(error)

        ensure
#          resource.always
        end

        Waves::Logger.info "#{request.method}: #{request.url} handled"# in #{(t*1000).round} ms."

        response.finish
      end

      # Takes a Waves::Request and returns a Waves::Response
#      def safe( request  )
#        # set a default content type -- this can be overridden by the resource
#        request.response.content_type = request.accept.default
#        resource = Waves.config.resource.new( request )
#        if request.response.body.empty?
#          request.response.write resource.process.to_s
#        else
#          resource.process
#        end
#        # okay, we've handled the request, now write the response unless it was already done
#        request.response.finish
#      end

    end

  end

end
