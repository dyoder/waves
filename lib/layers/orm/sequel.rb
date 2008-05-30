require 'sequel'
require File.dirname(__FILE__) / :sequel / :tasks / :schema if defined?(Rake)

module Waves
  module Layers
    module ORM
      
      module Sequel

        def self.included(app)
          
          def app.database ; @sequel ||= ::Sequel.open( config.database ) ; end
          
          app.instance_eval do
            
            auto_create :Models do
              include AutoCode
              auto_create_class true, ::Sequel::Model
              auto_load true, :directories => [ :models ]
              auto_eval true do
                default = superclass.basename.snake_case.pluralize.intern
                if @dataset && @dataset.opts[:from] != [ default ]
                  # don't clobber dataset from autoloaded file
                else
                  set_dataset Waves.application.database[ basename.snake_case.pluralize.intern ]
                end
              end
            end
            
          end
        end

      end
    end
  end
end
