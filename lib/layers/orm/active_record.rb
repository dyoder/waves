class Symbol
  # Protect ActiveRecord from itself by undefining the to_proc method.
  # Don't worry, AR will redefine it.
  alias :extensions_to_proc :to_proc
  remove_method :to_proc
end
require 'active_record'
require "#{File.dirname(__FILE__)}/active_record/tasks/schema"    if defined?(Rake)
require "#{File.dirname(__FILE__)}/active_record/tasks/generate"  if defined?(Rake)


module Waves
  module Layers
    module ORM

      module ActiveRecord

        # def active_record
        #   unless @active_record
        #     ::ActiveRecord::Base.establish_connection(config.database)
        #     @active_record = ::ActiveRecord::Base.connection
        #   end
        #   @active_record
        # end

        # def database
        #   @database ||= active_record
        # end

        def model_config(context, name)
          active_record
          context.set_table_name(name)
        end
        
        
        def self.included(app)
          
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
            
          Waves::Controllers::Base.module_eval do
            def all #:nodoc:
              model.find(:all)
            end
            
            def find( id ) #:nodoc:
              model.find(id) or not_found
            end
            
            def create #:nodoc:
              model.create( attributes )
            end
            
            def delete( id ) #:nodoc:
              find( id ).destroy
            end
            
            def update( id ) #:nodoc:
              instance = find( id )
              instance.update_attributes( attributes )
              instance
            end
          end
          
        end
      end
    end
  end
end

