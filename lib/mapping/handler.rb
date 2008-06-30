module Waves

  module Mapping
    
    class Handler < Action
      
      attr_reader :exception
      
      def initialize( e, options )
        @exception = e ; options[:resource] ||= 'error'
        super( options )
      end
      
    end
    
  end

end