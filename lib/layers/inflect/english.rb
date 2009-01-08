module Waves
  module Layers
    module Inflect
      
      # Adds plural/singular methods for English to String
      module English
        
        def self.included(app)
          
          require 'english/inflect'
                    
          Waves::Resources::Mixin::ClassMethods.module_eval do
            def singular ; basename.snake_case.singular ; end
            def plural ; basename.snake_case.plural ; end
          end
            
          Waves::Resources::Mixin.module_eval do
            def singular ; self.class.singular ; end
            def plural ; self.class.plural ; end
          end
          
          Waves::Resources::Paths.module_eval do
            def resource ; self.class.resource.singular ; end
            def resources ; self.class.resource.plural ; end
          end
          
        end
        
      end
    end
  end
end



