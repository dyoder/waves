module Waves
  module Layers
    module SimpleErrors
      
      def self.included( app )
        
        app.module_eval do

          self::Views.module_eval do
            const_set( :Errors, Class.new(  ) )
          end
          
          self::Views::Errors.class_eval do
            include Waves::Views::Mixin
            def not_found_404(*args); end
            def server_error_500(*args); end
          end
        	
        end
      end
    end
  end
end