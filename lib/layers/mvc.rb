module Waves
  module Layers
    module MVC
      
      def self.included( app )
        
        app.module_eval do
          extend Autocode; extend Reloadable
                    
          autocreate( :Models, Module.new { 
            extend Autocode; include Waves::Foundations::Reflection 
            })
          autocreate( :Views, Module.new { 
            extend Autocode; include Waves::Foundations::Reflection
            include Waves::Views::Mixin 
            autocreate( :Default, Class.new )
            })
          autocreate( :Controllers, Module.new { 
            extend Autocode; include Waves::Foundations::Reflection
            include Waves::Controllers::Mixin 
            autocreate( :Default, Class.new )
            })
            
          # accessor methods for modules and other key application objects ...
          def self.controllers ; self::Controllers ; end
      		def self.models ; self::Models ; end
      		def self.views ; self::Views ; end
            
        end
      end
    end
  end
end