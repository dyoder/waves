module Waves
  module Layers
    module Inflect
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



