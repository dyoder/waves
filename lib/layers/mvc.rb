module Waves
  module Layers
    # The MVC layer establishes the Models, Views, Controllers, and Helpers namespaces inside 
    # a Waves application.  In each namespace, undefined constants are handled by AutoCode, which
    # loads the constant from the correct file in the appropriate directory if it exists, or creates
    # from default otherwise.
    module MVC

      def self.included( app )
        
        def app.models ; self::Models ; end
        def app.views ; self::Views ; end
        def app.controllers ; self::Controllers ; end
        def app.helpers ; self::Helpers ; end
        
        app.auto_create_module( :Models ) do
          include AutoCode
          auto_create_class :Default
          auto_load :Default, :directories => [:models]
        end
        
        app.auto_eval( :Models ) do
          auto_create_class true, app::Models::Default
          auto_load true, :directories => [ :models ]
        end

        app.auto_create_module( :Views ) { include AutoCode }
        
        app.auto_eval( :Views ) do
          auto_create_class :Default, Waves::Views::Base
          auto_load :Default, :directories => [:views]
          auto_create_class true, app::Views::Default
          auto_load true, :directories => [ :views ]
        end

        app.auto_create_module( :Controllers ) { include AutoCode }
        
        app.auto_eval( :Controllers ) do
          auto_create_class :Default, Waves::Controllers::Base
          auto_load :Default, :directories => [:controllers]
          auto_create_class true, app::Controllers::Default
          auto_load true, :directories => [ :controllers ]          
        end

        app.auto_create_module( :Helpers ) do
          include AutoCode
          auto_create_module { include Waves::Helpers::Default }
          auto_load true, :directories => [ :helpers ]
        end          

      end
    end
  end
end
