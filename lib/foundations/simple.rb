module Waves
  module Foundations
    module Simple
      
      def self.included( app )
        
        app.module_eval do

          extend Autocreate
          [ :Configurations, :Views].each do | name |
        		autocreate( name, Module.new ) do
              # dynamically access module constants
        			def self.[]( cname )
        			  eval("#{name}::#{cname.to_s.camel_case}")
        			end
        		end
        	end

          self::Configurations.module_eval do
            const_set( :Development, Class.new( Waves::Configurations::Default ) )
            const_set( :Mapping, Module.new { |mod| extend Waves::Mapping } )
          end
          
          self::Configurations::Mapping.module_eval do
            handle(Waves::Dispatchers::NotFoundError) { response.status = 404 }
          end
          
          # accessor methods for modules and other key application objects ...
        	class << self
        		def config ; Waves.config ; end
        		def configurations ; self::Configurations ; end
        		def controllers ; self::Controllers ; end
        		def models ; self::Models ; end
        		def helpers ; self::Helpers ; end
        		def views ; self::Views ; end
        	end
        	
        end
      end
    end
  end
end