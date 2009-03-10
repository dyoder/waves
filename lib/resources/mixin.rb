module Waves
  
  module Resources
    
    StatusCodes = {
      Waves::Dispatchers::NotFoundError => 404
    }
    
    
    module Mixin
      
      attr_reader :request
      
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

      # this is necessary because you can't define functors within a module because the functor attempts
      # to incorporate the superclass functor table into it's own
      def self.included( resource )
        
        resource.module_eval do 
      
          include ResponseMixin, Functor::Method ; extend ClassMethods

          def initialize( request ); @request = request ; end
      
          def process
            begin
              before ; body = send( request.method ) ; after
            rescue Waves::Dispatchers::Redirect => e
              raise e
            rescue Exception => e
              response.status = ( StatusCodes[ e.class ] || 500 )
              ( body = handler( e ) ) rescue raise e
              Waves::Logger.warn "Handled #{e.class}: #{e}"
              e.backtrace.each { |t| Waves::Logger.debug "    #{t}" }
            ensure
              always
            end
            return body
          end
      
          def to( resource )
            resource = case resource
            when Base
              resource
            when Symbol, String
              begin 
                Waves.main::Resources[ resource ]
              rescue NameError => e
                Waves::Logger.debug e.to_s
                e.backtrace.each { |t| Waves::Logger.debug "    #{t}" }
                raise Waves::Dispatchers::NotFoundError
              end
              Waves.main::Resources[ resource ]
            end
            r = traits.waves.resource = resource.new( request )
            r.process
          end
          
          def redirect( path ) ; request.redirect( path ) ; end
      
          # override for resources that may have long-running requests. this helps servers 
          # determine how to handle the request
          def deferred? ; false ; end
          
          before {} ; after {} ; always {}
          # handler( Waves::Dispatchers::Redirect ) { |e| raise e }
      
          %w( post get put delete head ).each do | method |
            on( method ) { not_found }
          end
                
        end
        
      end

    end
      
    class Base ; include Mixin ; end 

  end


end
