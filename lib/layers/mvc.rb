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
        

        app.instance_eval do
          # include AutoCode

          auto_create_module( :Models ) do
            include AutoCode
            auto_create_class
            auto_load true, :directories => [ :models ]
          end

          auto_create_module( :Views ) do
            include AutoCode
            auto_create_class true, Waves::Views::Base
            auto_load true, :directories => [ :views ]
          end

          auto_create_module( :Controllers ) do
            include AutoCode
            auto_create_class true, Waves::Controllers::Base
            auto_load true, :directories => [ :controllers ]
          end

          auto_create_module( :Helpers ) do
            include AutoCode
            auto_create_module
            auto_load true, :directories => [ :helpers ]
            auto_eval( true ){ include Waves::Helpers::Default }
          end          

        end
      end
    end
  end
end
