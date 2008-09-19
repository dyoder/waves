module Waves
  
  module Resources
    
    module Mixin
      
      attr_reader :request
      
      def self.included( target )
        target.module_eval do
          
          include ResponseMixin
          include Functor::Method
                    
          def self.singular ; basename.downcase ; end
          def self.plural ; basename.downcase.plural ; end
          def self.with( options ) ; @options = options ; yield ; @options = nil ; end
          def self.on( method, path, options = {}, &block )
            options.merge!( @options ) if @options
            options[ :path ] = ( path.is_a? Hash and path.values.first ) or path
            functor_with_self( method, Waves::Matchers::Resource.new( options ), &block )
          end
          def self.before( path = nil, options = {}, &block )
            options.merge!( @options ) if @options
            options[ :path ] = path
            functor_with_self( :before, Waves::Matchers::Resource.new( options ), &block )
          end
          def self.after( path = nil, options = {}, &block )
            options.merge!( @options ) if @options
            options[ :path ] = path
            functor_with_self( :after, Waves::Matchers::Resource.new( options ), &block )
          end
          def self.wrap( path = nil, options = {}, &block )
            before( path, options, &block )
            after( path, options, &block )
          end
          def self.handler( exception, &block ) ; functor( :handler, exception, &block ) ; end
          def self.always( &block ) ; define_method( :always, &block ) ; end
          
          before {} ; after {} ; always {}
          
          handler( Waves::Dispatchers::NotFoundError ) do | e |
            response.status = 404; response.body = 'Not Found!'
          end

        end
      end
      
      # Resources are initialized with a Waves::Request
      def initialize( request ); @request = request ; end
      def singular ; self.class.singular ; end
      def plural ; self.class.plural ; end
      def paths( rname = nil )
        if rname
          Waves.main::Resources[ rname ]::Paths.new( request )
        else
          self.class::Paths.new( request )
        end
      end
      def redirect( path ) ; request.redirect( path ) ; end
      def render( path, assigns = {} ) ; Waves::Views::Base.process( request ) { render( path, assigns ) }; end
    end
      
    class Base ; include Mixin ; end 

  end


end
