module Waves
  module Foundations
    module Default
      
      def self.included( app )
        
        app.module_eval do
          extend Autocode; extend Reloadable
          
          include Waves::Foundations::Simple
          include Waves::Layers::DefaultErrors
          include Waves::Layers::MVC
                         
          # Set autoloading from default.rb files
      	  autoinit :Configurations do
      	    autoload_class true, app.configurations["Default"]
            autoload_module :Mapping
      	  end        	
        	
        end
      end
    end
  end
end

