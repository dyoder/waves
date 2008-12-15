module Waves

  module Mapping
    
    class Handler < Action
      
      attr_reader :exception
      
      def initialize( e, options )
        @exception = e ; options[:resource] ||= 'error'
        super( options )
      end
      
      def call( *args )
        request, exception = args
        if @block
          @resource.new( request ).instance_exec( exception, &@block )
        end
      end
      
    end
    
  end

end