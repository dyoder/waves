module Waves
  
  module Resources
    
    module Mixin
      
      attr_reader :request

      include ResponseMixin

      def initialize(request); @request = request; end

      def with( resource, &block ) ; @resource = resource ; yield if block_given? ; self ; end
      def controller ; @controller ||= controllers[ @resource.singular ].process(@request) { self } ; end
      def view ; @view ||= views[ @resource.singular ].process( @request ) { self } ; end
      def render( method ) ; view.send(method, @resource => @data ) ; end
      def redirect( mapping, assigns ) ; request.redirect( mapping.named[mapping].call( assigns ) ) ; end
      def method_missing( name, *args, &block)
        @data = controller.send( name, *args, &block )
        return self
      end
      def collection ; @data ; end
      def instance ; @data ; end
      # have to define this explicitly for now because for some reason sequel defines it on Object ...
      def all ; method_missing(:all) ; end
      
  end

  # :)
  const_set( :Base, Class.new ).module_eval { include Mixin }  

end
