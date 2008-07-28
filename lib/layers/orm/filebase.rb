module Waves
  module Layers
    module ORM
      
      # Work in Progress
      module Filebase
        
        def self.included(app)
          app.module_eval do
            auto_eval( :Models ) do
              auto_eval( true ) { include ::Filebase::Model[ :db / self.name.snake_case ] }
            end
          end
        end
        
      end
    
    end
    
  end
  
end