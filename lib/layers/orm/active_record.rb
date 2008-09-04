module Waves
  module Layers
    module ORM

      # Sets up the ActiveRecord connection and configures AutoCode on Models, so that constants in that
      # namespace get loaded from file or created as subclasses of Models::Default
      module ActiveRecord
        
        # On inclusion, this module:
        # - creates on the application module a database method that establishes and returns the ActiveRecord connection
        # - arranges for autoloading/autocreation of missing constants in the Models namespace
        # - defines ActiveRecord-specific helper methods on Waves::Controllers::Base
        # - adds 'active-record' to the application-level dependencies index, Waves.config.dependencies
        # 
        # The controller helper methdods are:
        # - all
        # - find(name)
        # - create
        # - delete(name)
        # - update(name)


        def self.included(app)
          Waves.config.dependencies << 'activerecord'

          require 'active_record'
          require "#{File.dirname(__FILE__)}/active_record/tasks/schema"    if defined?(Rake)
          require "#{File.dirname(__FILE__)}/active_record/tasks/generate"  if defined?(Rake)
          
          def app.database
            unless @database
              ::ActiveRecord::Base.establish_connection(config.database)
              @database = ::ActiveRecord::Base.connection
            end
            @database
          end
                      
          app.auto_create_module( :Models ) do
            include AutoCode
            auto_create_class :Default, ::ActiveRecord::Base
            auto_load :Default, :directories => [ :models ]
          end
          
          app.auto_eval :Models do
            auto_create_class true, app::Models::Default
            auto_load true, :directories => [ :models ]

            auto_eval true do
              app.database
              set_table_name basename.snake_case.pluralize.intern
            end
          end
          
          Waves::Controllers::Base.instance_eval do
            include Waves::Layers::ORM::ActiveRecord::ControllerMethods
          end
          
        end
        
        # Mixed into Waves::Controllers::Base.  Provides ORM-specific helper methods for model access.
        module ControllerMethods
          def all
            model.find(:all)
          end
          
          def find( name )
            model.find_by_name(name) or not_found
          end
          
          def create
            model.create( attributes )
          end
          
          def delete( name )
            find( name ).destroy
          end
          
          def update( name )
            instance = find( name )
            instance.update_attributes( attributes )
            instance
          end
        end
        
      end
    end
  end
end

