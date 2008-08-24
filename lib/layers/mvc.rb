module Waves
  module Layers
    # The MVC layer establishes the Models, Views, Controllers, and Helpers namespaces inside 
    # a Waves application.  In each namespace, undefined constants are handled by AutoCode, which
    # loads the constant from the correct file in the appropriate directory if it exists, or creates
    # from default otherwise.
    module MVC

      def self.included( app )
        
        app.auto_create_module( :Models ) do
          include AutoCode
          auto_create_class :Default
          auto_load :Default, :directories => [ :models ]
        end
        
        app.auto_eval( :Models ) do
          auto_create_class true, app::Models::Default
          auto_load true, :directories => [ :models ]
        end

        app.auto_create_module( :Views ) do
          include AutoCode
          auto_create_class :Default, Waves::Views::Base
          auto_load :Default, :directories => [ :views ]
        end
        
        app.auto_eval( :Views ) do
          auto_create_class true, app::Views::Default
          auto_load true, :directories => [ :views ]
        end

        app.auto_create_module( :Controllers ) do
          include AutoCode
          auto_create_class :Default, Waves::Controllers::Base
          auto_load :Default, :directories => [ :controllers ]
        end
        
        app.auto_eval( :Controllers ) do
          auto_create_class true, app::Controllers::Default
          auto_load true, :directories => [ :controllers ]          
        end

        app.auto_create_module( :Helpers ) do
          include AutoCode
          auto_create_module( :Default ) { include Waves::Helpers::BuiltIn }
          auto_load :Default, :directories => [ :helpers ]
          auto_create_module( true ) { include app::Helpers::Default }
          auto_load true, :directories => [ :helpers ]
        end
        
        app.auto_eval :Resources do
          auto_create_class :Default, Waves::Resources::Base
          auto_load :Default, :directories => [ :resources ]
          auto_eval :Default do
            
            def controller( method = nil, *args, &block )
              @controller ||= app::Controllers[ singular ].process( @request ) { self }
            end

            def view( method = nil, assigns = nil)
              @view ||= app::Views[ singular ].process( @request ) { self }
            end
            
          end
          auto_create_class true, app::Resources::Default
          auto_load true, :directories => [ :resources ]          
        end
                          
      end
    end
  end
end
