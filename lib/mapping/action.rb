module Waves

  module Mapping
    
    class Action
      
      # TODO: Make this more generic and able to support Handler (or push add'l code into Handler).
      # Should support anonymous blocks (i.e. that don't call a method on Resource), or cases where
      # no path was provided. Should also always use :path rather than relying on target (this is
      # actually code in patter), and add code for :scheme, :domain, etc. constraints (Constraints).
      # 
      # Can some o the resource determination related code be factored out of there or simplified?
      
      attr_reader :name, :resource, :pattern, :constraints, :descriptors
      
      def initialize( options, &block )
        @name = name = options[:name]
        @pattern = pattern = Pattern.new( options )
        @constraints = Constraints.new( options )
        @descriptors = Descriptors.new( options )
        if rname = options[ :resource ]
          @resource = resource = Waves.application[:resources][ rname ]
        else
          resource = Waves.application[:resources][ :default ]
          @resource = Waves::Resources::Proxy
        end
        resource.instance_eval { define_method name, &block } if name and block_given?
        resource::Paths.instance_eval { define_method( name ) { |*args| generate( options[ :pattern ], args ) } }
      end
      
      def bind( request )
        ( constraints.satisfy?( request ) and 
          ( params = pattern.match( request ) ) and Binding.new( self, params ) )
      end

      def threaded?
        descriptors.threaded?
      end
      
    end
    
    class Binding
      
      def initialize( action, params )
        @action = action ; @params = params
      end
      
      def call( request )
        request.params.merge!( @params )
        @action.resource.new( request ).send( @action.name )
      end
    
    end
    
  end

end