module Waves
  
  module Resources
    
    module Mixin
      
      attr_reader :request
      
      def self.included( target )
        target.module_eval do
          
          include ResponseMixin
          
          def self.singular ; basename.downcase ; end
          def self.plural ; basename.downcase.plural ; end
          def self.with( options ) ; @options = options ; yield ; @options = nil ; end
          def self.on( method, path, options = {}, &block )
            options.merge!( @options ) if @options
            options[ :path ] = ( path.is_a? Hash and path.values.first ) or path
            functor( method, Waves::Matchers::Request.new( options ), &block )
          end
          def self.before( path = true, options = {}, &block )
            options.merge!( @options ) if @options
            options[ :path ] = path
            functor( :before, Waves::Matchers::Request.new( options ), &block )
          end
          def self.after( path = true, options = {}, &block )
            options.merge!( @options ) if @options
            options[ :path ] = path
            functor( :after, Waves::Matchers::Request.new( options ), &block )
          end
          def self.wrap( path = true, options = {}, &block )
            before( path, options, &block )
            after( path, options, &block )
          end
          def self.handler( exception, &block ) ; functor( :handler, exception, &block ) ; end
          def self.always( &block ) ; define_method( :always, &block ) ; end

          include Functor::Method

          functor( :post ) { post( request ) }
          functor( :get ) { get( request ) }
          functor( :put ) { put( request ) }
          functor( :delete ) { delete( request ) }
          functor( :before ) {}
          functor( :after ) {}
          functor( :always ) {}
          functor( :handler, Waves::Dispatchers::NotFoundError ){ |e|  response.status = 404; response.body = 'Not Found!' }

        end
      end
      
      # Resources are initialized with a Waves::Request
      def initialize(request); @request = request ; end
      def singular ; self.class.singular ; end
      def plural ; self.class.plural ; end
      def redirect( path ) ; request.redirect( path ) ; end
      def render( path, assigns = {} ) ; Waves::Views::Base.process( request ) { render( path, assigns ) }; end
    end
      
    class Base ; include Mixin ; end 

  end


end
