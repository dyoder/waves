module Waves

  module Mapping
    
    class Handler < Action
      
      attr_reader :exception
      
      def initialize( e, options )
        @exception = e
        super
      end
    
  end

end