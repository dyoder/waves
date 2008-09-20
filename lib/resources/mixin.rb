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
          def self.on( method, path = true, options = nil, &block )
            if path.is_a? Hash
              generator = path.keys.first
              path = path.values.first
            end
            if options
              options[ :path ] = path
            else
              options = { :path => path }
            end
            options = @options.merge( options ) if @options
            matcher = Waves::Matchers::Resource.new( options )
            methods = case method
              when nil then nil
              when true then [ :post, :get, :put, :delete ]
              when Array then method
              else [ method ]
            end
            methods.each do | method |
              functor_with_self( method, matcher, &block )
            end
            # define generator method
          end
          def self.before( path = nil, options = {}, &block )
            on( :before, path, options, &block )
          end
          def self.after( path = nil, options = {}, &block )
            on( :after, path, options, &block )
          end
          def self.wrap( path = nil, options = {}, &block )
            before( path, options, &block )
            after( path, options, &block )
          end
          def self.handler( exception, &block ) ; functor( :handler, exception, &block ) ; end
          def self.always( &block ) ; define_method( :always, &block ) ; end
          
          before {} ; after {} ; always {}
          %w( post get put delete ).each do | method |
            on( method ) { not_found }
          end
          
          handler( Waves::Dispatchers::NotFoundError ) do | e |
            response.status = 404; response.content_type = 'text/html'
            Waves::Views::Errors.process( request ) { not_found_404 }
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
      def to( resource )
        resource = case resource
        when Base
          resource
        when Symbol, String
          Waves.main::Resources[ resource ]
        end
        resource.new( request ).send( request.method )
      end
      def redirect( path ) ; request.redirect( path ) ; end
      def render( path, assigns = {} ) ; Waves::Views::Base.process( request ) { render( path, assigns ) }; end
    end
      
    class Base ; include Mixin ; end 

  end


end
