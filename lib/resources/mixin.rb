module Waves
  
  module Resources
    
    module Mixin
      
      attr_reader :request

      include ResponseMixin
      
      def self.included( target )
        def target.paths ; @paths ||= Object.new ; end
      end
      
      def initialize(request); @request = request ; end
      def resource ; self.class.basename.downcase ; end
      def resources ; resource.plural ; end
      def redirect( path ) ; request.redirect( path ) ; end
      def paths ; self.class.paths ; end
      
    end
      
    # :)
    const_set( :Base, Class.new ).module_eval { include Mixin }

  end


end
