module Waves

  # Mapping actions are evaluated in the context of a ResponseProxy.
  class ResponseProxy

    attr_reader :request

    include ResponseMixin

    def initialize(request)
      @request = request
    end

    def with( resource, &block ) ; @resource = resource ; yield if block_given? ; self ; end
    def controller ; @controller ||= controllers[ @resource.singular ].process(@request) { self } ; end
    def view ; @view ||= views[ @resource.singular ].process( @request ) { self } ; end
    def render( method ) ; view.send(method, @resource => @data ) ; end
    def redirect( mapping, assigns ) ; request.redirect( mapping.named[mapping].call( assigns ) ) ; end
    def method_missing( name, *args, &block)
      @data = controller.send( name, *args, &block ) unless @or and @data
      return self
    end
    def and ; self ; end
    def or ; @or = true ; end
    def collection ; @data ; end
    def instance ; @data ; end
    # have to define this explicitly for now because for some reason sequel defines it on Object ...
    def all ; method_missing(:all) ; end

  end

end
