module Waves
  module Layers
    module ORM
      
      module Filebase
        
        def self.included(app)
          app.module_eval
            auto_eval( :Models ) do
          	  include AutoCode
          	  auto_eval true { include Filebase::Model[ :db / self.name.snake_case ] }
          	end
          end
        end
        
      end
    
    end
    
  end
  
end
