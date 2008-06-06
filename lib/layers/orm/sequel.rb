gem 'sequel', '>= 2.0.0'
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
            
            Waves::Controllers::Base.module_eval do
              def all; model.all; end
              def find( name ); model[ :name => name ] or not_found; end
              def create; model.create( attributes ); end
              def delete( name ); find( name ).destroy; end
              
              def update( name )
                instance = find( name )
                instance.update_with_params( attributes )
                instance
              end
            end
            
          end
        end
      end
    end
  end
end
