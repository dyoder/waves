module Waves
  
  # Waves uses Layers to provide discrete, stackable, interchangeable bundles of functionality.
  # 
  # Developers can make use of Layers by including them directly in a Waves application:
  # 
  #   module MyApp
  #     include SomeLayer
  #   end
  module Layers
    
    # Creates the Configurations namespace and establishes the standard autoload-or-autocreate
    # rules.
    module Simple
      def self.included( app )

        def app.paths( r ) ; self::Resources[ r ].paths ; end
        
        app.instance_eval { include AutoCode }
        
        app.auto_create_module( :Configurations ) do
          include AutoCode
          auto_create_class true, Waves::Configurations::Default
          auto_create_module( :Mapping ) { extend Waves::Mapping }
          auto_load :Mapping, :directories => [:configurations]
          auto_load true, :directories => [:configurations]
        end
          
        app.auto_create_module( :Resources ) do
          include AutoCode
          auto_create_class true, Waves::Resources::Base
        end

      end
    end
  end
end
      