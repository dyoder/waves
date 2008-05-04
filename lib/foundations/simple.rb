module Waves
  module Foundations
    
    module Simple
      
      def self.included( app )

        app.instance_eval do
          include Autocode
          autocreate( :Configurations, Module.new {
            include Autocode
            autocreate( :Default, Class.new )
            autocreate( :Development, Class.new( Waves::Configurations::Default ))
            autocreate( :Mapping, Module.new { |mod| include Waves::Mapping })
          })
      		meta_def( :config ) { Waves.config }
      		meta_def( :configurations ) { self::Configurations }

        	include Waves::Layers::SimpleErrors
        	
        end
      end
    end
  end
end

