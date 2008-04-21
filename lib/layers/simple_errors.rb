module Waves
  module Layers
    module SimpleErrors
      
      def self.included( app )
        
        app.module_eval do

          self::Configurations::Mapping.module_eval do
            handle(Waves::Dispatchers::NotFoundError) { response.status = 404 }
          end
        	
        end
      end
    end
  end
end