module Waves

  module Mapping
    
    class Action
      
      attr_accessor :name, :resource, :pattern, :constraints, :descriptors
      
      def initialize( options, &block )
        name = options[:name]
        pattern = Pattern.new( options )
        matcher = Constraints.new( options )
        descriptors = Descriptors.new( options )
        resource = Waves.application[:resources][ options[:resource] ]
        resource.instance_eval{ define_method n, &block } if block_given?
      end
      
      # how / when can i take the results of the pattern match 
      # and merge them with the request params ... can't do it here
      # because a number of actions may be run, but I can't store
      # it as state because actions are shared between requests
      def call?( request )
        constraints.satisfy?( request ) and pattern.match( request )
      end
      
      def call( request )
        resource.new( request ).send( name )
      end
      
      def method_missing( name, *args )
        descriptors.send( name, *args )
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
    end

  end

end
