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

        def app.config ; Waves.config ; end
        def app.configurations ; self::Configurations ; end
        def app.paths ; configurations::Mapping.named; end
        def app.resources ; self::Resources ; end
        
        app.instance_eval { include AutoCode }
        
        app.auto_create_module( :Configurations ) do
          include AutoCode
          auto_create_class true, Waves::Configurations::Default
          auto_load :Mapping, :directories => [:configurations]
          auto_load true, :directories => [:configurations]
          auto_eval :Mapping do
            extend Waves::Mapping
          end
          
          auto_create_module( :Resources ) do
            include AutoCode
            auto_create_class true, Waves::Resources::Base
            # this should probably be refactored into a separate layer
            auto_eval do
              def resource ; self.class.name ; end
              def resources ; resource.plural ; end
              def controller ; @controller ||= controllers[ resource ].process( @request ) { self } ; end
              def view ; @view ||= views[ resource ].process( @request ) { self } ; end
              def render( method ) ; view.send( method, ( @data.kind_of? Enumerable ? resources : resource ) => @data ) ; end
              def redirect( path ) ; request.redirect( path ) ; end
              def method_missing( name, *args, &block) ; @data = controller.send( name, *args, &block ) ; end
              # have to define this explicitly for now because for some reason sequel defines it on Object ...
              def all ; method_missing( :all ) ; end
            end
          end

        end
      end
    end
  end
end
      