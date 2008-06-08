module Waves

  module Mapping
    
    class Action
      
      attr_accessor :name, :resource, :pattern, :constraints, :descriptors
      
      def initialize( options, &block )
        name = options[:name]
        pattern = Pattern.new( options )
        matcher = Constraints.new( options )
        descriptors = Descriptors.new( options )
        resource = options[:resource] or Class.new( Waves::Resources::Base )
        resource.instance_eval{ define_method n, &block } if block_given?
      end
      
      def call?( request )
        constraints.satisfy?( request ) and @matches = pattern.match( request )
      end
      
      def call( request, *args )
        resource.send( name, *@matches )
      end
      
      def method_missing( name, *args )
        descriptors.send( name, *args )
      end
      
    end

  end

end
