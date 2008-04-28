require 'sequel'

module Waves
  module Foundations
    module Default
      
      def self.included( app )
        
        app.module_eval do
          extend Autocode; extend Reloadable
          
          include Waves::Foundations::Simple

        	  autoinit :Configurations do
        	    autoload_class true, app.configurations["Default"]
              autoload :Mapping
        	  end
        	  
        	  autoinit :Helpers do
        	    autoload true, :exemplar => app.helpers["Default"]
        	  end
        	  
        	  autoinit :Models do
        	    extend Autocode
              autoload_class true, Sequel::Model
              autocreate true, app.models["Default"] do
                set_dataset app.database[ basename.snake_case.plural.intern]
              end
        	  end
        	  
            autoinit :Views do
              extend Autocode
              autoload_class true, app.views["Default"]
              autocreate true, app::Views::Default
            end
            
            autoinit :Controllers do
              autoload_class true, app.controllers["Default"]
              autocreate true, app::Controllers::Default
            end
          	  

          # accessor methods for modules and other key application objects ...
          class << self
            def database ; @database ||= Sequel.open( config.database ) ; end
          end
        	
          include Waves::Layers::DefaultErrors
        	
        end
      end
    end
  end
end

