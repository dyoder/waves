module Waves
  module Foundations
    module Simple
      
      def self.included( app )
        
        app.module_eval do

          const_set( :Configurations, Module.new {
            const_set( :Development, Class.new( Waves::Configurations::Default ))
            const_set( :Mapping, Module.new { |mod| extend Waves::Mapping })
          })
          const_set( :Models, Module.new )
          const_set( :Views, Module.new { include Waves::Views::Mixin })
          const_set( :Controllers, Module.new { include Waves::Controllers::Mixin })
          const_set( :Helpers, Module.new )
          
          %w( Configurations Models Views Controllers Helpers ).each do |name|
            const_get(name).module_eval do
              def self.[]( cname ) const_get( cname.to_s.camel_case ) end
            end
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
        	
        	include Waves::Layers::SimpleErrors
        	
        end
      end
    end
  end
end