module Waves
  
  module Resources
    
    module Mixin
      
      attr_reader :request

      include ResponseMixin
      
      def self.included( target )
        parent = target.superclass
        base = parent.respond_to?( :paths ) ? parent.paths : Waves::Resources::Paths
        target.module_eval do
          const_set( :Paths, Class.new( base ) )
          def self.paths ; @object ||= self::Paths.new( self ) ; end
          def self.singular ; basename.downcase ; end
          def self.plural ; basename.downcase.plural ; end
        end
      end
      
      include Functor::Method

      def self.on( method, path, options = {}, &block )
        options[ :path ] = ( path.is_a? Hash and path.values.first ) or path
        functor( method, Matchers::ContentType.new( options[ :content_type ] ), Matchers::Accepts.new( options ), 
          Matchers::URI.new( options ), Matchers::Query.new( options[:query] ), &block )
        self::Paths.define_path( path.keys.first, options[ :path ] ) if path.is_a? Hash
      end
      
      def self.before( method = true, &block ); functors[ method ].before( &block ); end
      def self.after( method = true, &block ); functors[ method ].after( &block ); end
      def self.wrap( method = true, &block ); functors[ method ].wrap( &block ); end
      def self.handler( exception, &block ) ; functor( :handler, exception, &block ) ; end
      def self.always( &block ) ; define_method( :always, &block ) ; end
      
      # Resources are initialized with a Waves::Request
      def initialize(request); @request = request ; end
      def singular ; self.class.singular ; end
      def plural ; self.class.plural ; end
      def redirect( path ) ; request.redirect( path ) ; end
      def paths ; self.class.paths ; end
      def render( path, assigns = {} ) ; Waves::Views::Base.process( request ) { render( path, assigns ) }; end
    end
      
    # :)
    class Base ; include Mixin ; end 

  end


end
