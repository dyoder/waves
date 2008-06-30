module Waves

  module Mapping
    
    class Action
      
      # no path was provided. Should also always use :path rather than relying on target (this is
      # actually code in patter), and add code for :scheme, :domain, etc. constraints (Constraints).
      # 
      # Can some o the resource determination related code be factored out of there or simplified?
      
      def initialize( options )
        @name = name = options[:name] ; @pattern = pattern = Pattern.new( options )
        @constraints = Constraints.new( options ) ; @descriptors = Descriptors.new( options )
        if rname = options[ :resource ]
          @resource = resource = Waves.application[:resources][ rname ]
        else
          resource = Waves.application[:resources][ :default ]
          @resource = Waves::Resources::Proxy
        end
        if name
          block = options[:block]
          resource.instance_eval { define_method( name, &block ) } if block
          resource::Paths.instance_eval { define_method( name ) { |*args| generate( options[ :path ], args ) } }
        end
      end
      
      def bind( request )
        ( @constraints.satisfy?( request ) and 
          ( params = @pattern.match( request ) ) and Binding.new( self, params ) )
      end
      
      def call( request )
        if @name
          @resource.new( request ).send( @name )
        elsif @block
          @resource.new( request ).instance_eval( &@block )
        end
      end

      def threaded?
        @descriptors.threaded?
      end
      
    end
    
    class Binding
      
      def initialize( action, params )
        @action = action ; @params = params
      end
      
      def call( request )
        request.params.merge!( @params )
        @action.call( request )
      end
    
      def method_missing(name,*args,&block)
        @action.respond_to?( name ) ? @action.send( name, *args, &block ) : super
      end
    end
    
  end

end