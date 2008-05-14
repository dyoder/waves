require 'sequel'
require File.dirname(__FILE__) / :sequel / :tasks / :schema if defined?(Rake)
require File.dirname(__FILE__) / :sequel / :model

module Waves
  module Layers
    module ORM
      
      module Sequel

        def self.included(app)
          
          def app.database ; @sequel ||= ::Sequel.open( config.database ) ; end
          
          app.instance_eval do
            
            auto_eval :Models do
              auto_create_class true, Waves::Layers::ORM::Model do
                set_dataset app.database[ basename.snake_case.plural.intern]
              end
              auto_load true, :directories => [:models]
        	  end
            
          end
        end

      end
    end
  end
end

