module Waves
  module Layers
    module Inflect
      
      # Adds plural/singular methods for English to String
      module English
        
        def self.included(app)
          
          require 'layers/inflect/english/rules'
          require 'layers/inflect/english/string'
          
          String.class_eval do
            include Waves::Layers::Inflect::English::StringMethods
          end
          
        end
        
      end
    end
  end
end



