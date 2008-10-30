module Waves
  
  module Resources
    
    module Mixin
      
      attr_reader :request
      
      def self.included( target )
        target.module_eval do
          include ResponseMixin, Functor::Method
          extend ClassMethods
          before {} ; after {} ; always {}
          %w( post get put delete head ).each do | method |
            on( method ) { not_found }
          end
        end
      end
      
      module ClassMethods
          
        def paths
          unless @paths
            resource = self
            @paths = Class.new( superclass.respond_to?( :paths ) ? superclass.paths : Waves::Resources::Paths ) do
              @resource = resource
              def self.resource ; @resource ; end
            end
          else
            @paths
          end
        end
        def with( options ) ; @options = options ; yield ; @options = nil ; end
        def on( method, path = true, options = nil, &block )
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
          paths.module_eval { 
            define_method( generator ) { | *args | generate( path, args ) }
          } if generator
        end
        def before( path = nil, options = {}, &block )
          on( :before, path, options, &block )
        end
        def after( path = nil, options = {}, &block )
          on( :after, path, options, &block )
        end
        def wrap( path = nil, options = {}, &block )
          before( path, options, &block )
          after( path, options, &block )
        end
        def handler( exception, &block ) ; functor( :handler, exception, &block ) ; end
        def always( &block ) ; define_method( :always, &block ) ; end
        
      end
      
      # Resources are initialized with a Waves::Request
      def initialize( request ); @request = request ; end
      
      def process
        begin
          # invoke the request method, wrapped by the before and after methods
          before
          body = send( request.method )
          request.response.write( body ) if body.respond_to?( :to_s )
          after
        rescue Waves::Dispatchers::NotFoundError 
          request.response.status = 404
          request.response.body = "Resource not found"
        rescue Exception => e
          # handle any exceptions using the resource handlers, if any
          Waves::Logger.info "process caught: #{e.class.name} : #{e.message}"
          e.backtrace.each do |t|
            Waves::Logger.info "    #{t}"
          end
          if self.respond_to? :handler
            ( request.response.body = handler( e ) ) rescue raise e
          else
            request.response.status = 500
            request.response.body = "#{e.inspect}: \n#{e.backtrace[0..5].join("\n")}\n...\n"
          end
        ensure
          # no matter what happens, also run the resource's always method
          always
        end
      end
      
      def to( resource )
        resource = case resource
        when Base
          resource
        when Symbol, String
          begin 
            Waves.main::Resources[ resource ]
          rescue NameError
            raise Waves::Dispatchers::NotFoundError 
          end
          Waves.main::Resources[ resource ]
        end
        r = traits.waves.resource = resource.new( request )
        r.process
        nil
      end
      def redirect( path ) ; request.redirect( path ) ; end
      def render( path, assigns = {} ) ; Waves::Views::Base.process( request ) { render( path, assigns ) }; end
      
      # override for resources that may have long-running requests. this helps servers (esp. event-driven)
      # determine how to handle the request
      def deferred? ; false ; end
    end
      
    class Base ; include Mixin ; end 

  end


end
