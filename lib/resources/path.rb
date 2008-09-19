module Waves
  
  module Resources
    
    class Paths
      
      def initialize( request ) ; end
      def method_missing( name, *args ) ; '#' ;end
    end

  end

end