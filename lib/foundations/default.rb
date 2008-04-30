require 'sequel'

module Waves
  module Foundations
    module Default
      
      def self.included( app )
        
        app.module_eval do
          extend Autocode; extend Reloadable
          
          include Waves::Foundations::Simple
          include Waves::Layers::MVC
          
          autocreate( :Helpers, Module.new {
            extend Autocode; include Reflection 
            autocreate( :Default, Module.new )
            })
                
          # Set autoloading from default.rb files
      	  autoinit :Configurations do
      	    autoload_class true, app.configurations["Default"]
            autoload :Mapping
      	  end
      	  
      	  autoinit :Models do
            autoload_class true, Sequel::Model
            autocreate true, app.models["Default"] do
              set_dataset app.database[ basename.snake_case.plural.intern]
            end
      	  end
      	  
          autoinit :Views do
            autoload_class true, app.views["Default"]
            autocreate true, app::Views::Default
          end
          
          autoinit :Controllers do
            autoload_class true, app.controllers["Default"]
            autocreate true, app::Controllers::Default
          end

      	  autoinit :Helpers do
      	    autoload true, :exemplar => app.helpers["Default"]
      	  end
      	  
          # accessor methods for modules and other key application objects ...
          def self.database ; @database ||= Sequel.open( config.database ) ; end
      		def self.helpers ; self::Helpers ; end
        	
          include Waves::Layers::DefaultErrors
        	
        end
      end
    end
  end
end

