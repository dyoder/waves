require 'sequel'
require File.dirname(__FILE__) / :sequel / :tasks / :schema if defined?(Rake)

module Waves
  module Layers
    module ORM
      
      module Sequel

        def self.included(app)
          
          def app.database ; @sequel ||= ::Sequel.open( config.database ) ; end
          
          app.instance_eval do
            
            auto_eval :Models do
              auto_create_class true, ::Sequel::Model
              auto_eval true do
                set_dataset Waves.application.database[ basename.snake_case.pluralize.intern ]
              end
              auto_load true, :directories => [:models]
            end
            
          end
        end

      end
    end
  end
end
