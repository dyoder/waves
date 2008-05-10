module Waves
  module Layers
    module Simple
      def self.included(app)

        def app.config ; Waves.config ; end
        def app.configurations ; self::Configurations ; end
        
        app.instance_eval do

          include Autocode
          
          autocreate( :Configurations, Module.new) do
            include Autocode
            autocreate_class true, Waves::Configurations::Default
            autocreate_module( :Mapping ) { extend Waves::Mapping }
            autoload_class
          end

          include Waves::Layers::SimpleErrors

        end
      end
    end
  end
end
      