module Waves
  module Layers
    module ORM # :nodoc:
      
      # The Sequel ORM layer sets up the Sequel connection and configures AutoCode on Models, so that constants in that
      # namespace get loaded from file or created as subclasses of Models::Default.  The dataset for models is set to the
      # snakecased version of the model's class name.
      module Sequel
        # On inclusion, this module:
        # - creates on the application module a database method that establishes the Sequel connection
        # - arranges for autoloading/autocreation of missing constants in the Models namespace
        # - defines Sequel-specific helper methods on Waves::Controllers::Base
        # - adds 'sequel' to the application-level dependencies index, Waves.config.dependencies
        # 
        # The controller helper methdods are:
        # - all
        # - find(name)
        # - create
        # - delete(name)
        # - update(name)
        #
        
        
        def self.included(app)
          
          gem 'sequel', '>= 2.0.0'
          require 'sequel'
          require "#{File.dirname(__FILE__)}/sequel/tasks/schema" if defined?(Rake)
          require "#{File.dirname(__FILE__)}/sequel/tasks/generate" if defined?(Rake)
          
          def app.database ; @sequel ||= ::Sequel.open( Waves.config.database ) ; end
                      
          app.auto_create_module( :Models ) do
            include AutoCode
            auto_create_class :Default, ::Sequel::Model
            auto_load :Default, :directories => [ :models ]
          end
          
          app.auto_eval :Models do
            auto_create_class true, app::Models::Default
            auto_load true, :directories => [ :models ]
            # set the Sequel dataset based on the model class name
            # note that this is not done for app::Models::Default, as it isn't 
            # supposed to represent a table
            auto_eval true do
              default = superclass.basename.snake_case.pluralize.intern
              if @dataset && @dataset.opts[:from] != [ default ]
                # don't clobber dataset from autoloaded file
              else
                if respond_to? :set_dataset
                  set_dataset Waves.main.database[ basename.snake_case.pluralize.intern ]
                end
              end
            end
          end
            
          Waves::Controllers::Base.instance_eval do
            include Waves::Layers::ORM::Sequel::ControllerMethods
          end
            
        end

        # Mixed into Waves::Controllers::Base.  Provides ORM-specific helper methods for model access.
        module ControllerMethods
          def all
            model.all
          end
          
          def find( name )
            model[ :name => name ] or not_found
          end
          
          def create
            model.create( attributes.to_hash )
          end
          
          def delete( name )
            find( name ).destroy
          end
          
          def update( name )
            instance = find( name )
            instance.update_with_params( attributes.to_hash )
            instance
          end
        end
        
      end    
    end
  end
end
