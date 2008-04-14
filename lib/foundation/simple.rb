module Waves
  module Foundations
    module Simple
      
      def self.included?( app )
        
        app.instance_eval do
          module Configurations
            class Test < Waves::Configurations::Default ; end
            module Mapping
              extend Waves::Mapping
            end
          end
          
          extend Autocreate
          [ :Configurations, :Models, :Views, :Controllers, :Helpers ].each do | name |
        		autocreate( name, Module.new ) do
              # dynamically access module constants
        			def self.[]( cname )
        			  eval("#{name}::#{cname.to_s.camel_case}")
        			end
        		end
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