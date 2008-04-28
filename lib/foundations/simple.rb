module Waves
  module Foundations
    module Simple
      
      module Reflection
        def self.included( mod )
          mod.module_eval do
            def self.[]( cname ) const_get( cname.to_s.camel_case ) end
          end
        end
      end
      
      def self.included( app )

        app.module_eval do

          extend Autocode; extend Reloadable; 
          autocreate( :Configurations, Module.new {
            extend Autocode; include Reflection
            autocreate( :Default, Class.new )
            autocreate( :Development, Class.new( Waves::Configurations::Default ))
            autocreate( :Mapping, Module.new { |mod| extend Waves::Mapping })
          })
          autocreate( :Models, Module.new { 
            extend Autocode; include Reflection 
            })
          autocreate( :Views, Module.new { 
            extend Autocode; include Reflection
            include Waves::Views::Mixin 
            autocreate( :Default, Class.new )
            })
          autocreate( :Controllers, Module.new { 
            extend Autocode; include Reflection
            include Waves::Controllers::Mixin 
            autocreate( :Default, Class.new )
            })
          autocreate( :Helpers, Module.new {
            extend Autocode; include Reflection 
            autocreate( :Default, Module.new )
            })
          
          # accessor methods for modules and other key application objects ...
        	class << self
        		def config ; Waves.config ; end
        		def configurations ; self::Configurations ; end
        		def controllers ; self::Controllers ; end
        		def models ; self::Models ; end
        		def helpers ; self::Helpers ; end
        		def views ; self::Views ; end
        	end
        	
        	include Waves::Layers::SimpleErrors
        	
        end
      end
    end
  end
end