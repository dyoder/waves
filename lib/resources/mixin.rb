module Waves
  
  module Resources
    
    module Mixin
      
      attr_reader :request

      include ResponseMixin
      include Functor::Method
      
      def self.included( target )
        parent = target.superclass
        base = parent.respond_to?( :paths ) ? parent.paths : Waves::Mapping::Paths
        target.module_eval do
          const_set( :Paths, Class.new( base ) )
          def self.paths ; @object ||= self::Paths.new( self ) ; end
          def self.singular ; basename.downcase ; end
          def self.plural ; basename.downcase.plural ; end
        end
      end
      
      def initialize(request); @request = request ; end
      def singular ; self.class.singular ; end
      def plural ; self.class.plural ; end
      def redirect( path ) ; request.redirect( path ) ; end
      def paths ; self.class.paths ; end
      functor( :resource, Object, Object ) { | app, name | Waves.applications[ app.to_s ].resources[ name.to_s ] }
      functor( :resource, Object ) { | app, name | Waves.application.resources[ name.to_s ] }
      
    end
      
    # :)
    const_set( :Base, Class.new ).module_eval { include Mixin }

  end


end
