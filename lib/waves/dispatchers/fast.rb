module Waves

  module Dispatchers

    # Fold dispatch logic into one method.
    #
    # TODO: Re-enable before etc. as soon as available.
    #
    class Fast < Base

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

#        ensure
#          resource.always
        end

        Waves::Logger.info "#{request.method}: #{request.url} handled"

        response.finish
      end

    end
  end
end
