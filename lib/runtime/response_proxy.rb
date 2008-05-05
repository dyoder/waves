module Waves

  class ResponseProxy

    attr_reader :request

    include ResponseMixin

    def initialize(request); @request = request; end

    def resource( resource, &block )
      @resource = resource; yield.call
    end

    def controller( &block )
      lambda { Waves.application.controllers[ @resource ].process( @request, &block ) }
    end

    def view( &block )
      lambda { |val| Waves.application.views[ @resource ].process( @request, val, &block ) }
    end

    def redirect(path, status = '302'); @request.redirect(path, status); end

  end

end
