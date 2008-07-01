module Waves
  module Layers
    module Inflect
      module English
        module StringMethods
        
          def singular
            English::Rules.singular(self)
          end

          alias_method(:singularize, :singular)

          def plural
            English::Rules.plural(self)
          end

          alias_method(:pluralize, :plural)
        
        end
      end
    end
  end
end

