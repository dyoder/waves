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

            # TODO: be nice to DRY this up ... basically the same code 
            # as the mixin except with the singular / plural stuff
            # mixed in ...
            def generate( template, args )
              return "/#{ args * '/' }" unless template.is_a?( Array ) and not template.empty?
              path = []
              ( "/#{ path * '/' }" ) if template.all? do | want |
                case want
                when true then path += args
                when String then path << want
                when Symbol
                  case want
                  when :resource then path << resource
                  when :resources then path << resources
                  else path << args.shift
                  end
                when Regexp then path << args.shift
                when Hash
                  key, value = want.to_a.first
                  case key
                  when :resource then path << resource
                  when :resources then path << resources
                  else 
                    case value
                    when true then path += args
                    when String, Symbol, RegExp then path << args.unshift
                    end
                  end
                end
              end
            end
          end
          
        end
        
      end
    end
  end
end



