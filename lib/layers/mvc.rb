module Waves
  module Layers
    module MVC
      
      def self.included( app )
        
        app.module_eval do
          include Autocode
                    
          autocreate( :Models, Module.new { 
            include Autocode; include Waves::Foundations::Reflection 
          })
          autocreate( :Views, Module.new { 
            include Autocode; include Waves::Foundations::Reflection
            include Waves::Views::Mixin 
            autocreate( :Default, Class.new )
          })
          autocreate( :Controllers, Module.new { 
            include Autocode; include Waves::Foundations::Reflection
            include Waves::Controllers::Mixin 
            autocreate( :Default, Class.new )
          })
          autocreate( :Helpers, Module.new {
            extend Autocode; include Reflection 
            autocreate( :Default, Module.new )
          })
          
      		# merge these inits with the above now that they are in the same file
      		autoinit :Views do
            autoload_class true, app.views["Default"]
            autocreate true, app::Views::Default
          end
          
          autoinit :Controllers do
            autoload_class true, app.controllers["Default"]
            autocreate true, app::Controllers::Default
          end

      	  autoinit :Helpers do
      	    autoload_module true, :exemplar => app.helpers["Default"]
      	  end
      	  
          
            
        end
      end
    end
  end
end