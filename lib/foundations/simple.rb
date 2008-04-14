module Waves
  module Foundations
    module Simple
      
      def self.included( app )
        
        app.module_eval do

          extend Autocreate
          [ :Configurations, :Models, :Views, :Controllers, :Helpers ].each do | name |
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
          
          # accessor methods for modules and other key application objects ...
        	class << self
        		def config ; Waves::Application.instance.config rescue nil || Waves::Application.instance.config ; end
        		def configurations ; Test::Configurations ; end
        		def controllers ; Test::Controllers ; end
        		def models ; Test::Models ; end
        		def helpers ; Test::Helpers ; end
        		def views ; Test::Views ; end
        	end
        	
        end
      end
    end
  end
end