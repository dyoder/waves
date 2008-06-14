gem 'sequel', '>= 2.0.0'
require 'sequel'
require File.dirname(__FILE__) / :sequel / :tasks / :schema if defined?(Rake)

module Waves
  module Layers
    module ORM # :nodoc:
      
      # Sets up the Sequel connection and configures AutoCode on Models, so that constants in that
      # namespace get loaded from file or created as subclasses of Models::Default
      module Sequel

        # On inclusion, this module:
        # - creates on the application module a database method that establishes the Sequel connection
        # - arranges for autoloading/autocreation of missing constants in the Models namespace
        # - defines Sequel-specific helper methods on Waves::Controllers::Base
        # 
        # The controller helper methdods are:
        # - all
        # - find(name)
        # - create
        # - delete(name)
        # - update(name)
        #
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
              def all #:nodoc:
                model.all
              end
              
              def find( name ) #:nodoc:
                model[ :name => name ] or not_found
              end
              
              def create #:nodoc:
                model.create( attributes )
              end
              
              def delete( name ) #:nodoc:
                find( name ).destroy
              end
              
              def update( name ) #:nodoc:
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
