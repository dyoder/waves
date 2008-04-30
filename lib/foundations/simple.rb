module Waves
  module Foundations
    
    module Reflection
      def self.included( mod )
        mod.module_eval do
          def self.[]( cname ) const_get( cname.to_s.camel_case ) end
        end
      end
    end
    
    module Simple
      
      def self.included( app )

        app.module_eval do

          extend Autocode; extend Reloadable; 
          autocreate( :Configurations, Module.new {
            extend Autocode; include Reflection
            autocreate( :Default, Class.new )
            autocreate( :Development, Class.new( Waves::Configurations::Default ))
            autocreate( :Mapping, Module.new { |mod| extend Waves::Mapping })
          })
          
          # accessor methods for modules and other key application objects ...
        	class << self
        		def config ; Waves.config ; end
        		def configurations ; self::Configurations ; end
        	end
        	
        	include Waves::Layers::SimpleErrors
        	
        end
      end
    end
  end
end