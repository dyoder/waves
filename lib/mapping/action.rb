module Waves

  module Mapping
    
    class Action
      
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
        resource.paths.instance_eval { meta_def name, &pattern.generator }
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