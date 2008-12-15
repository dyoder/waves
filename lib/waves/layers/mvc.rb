module Waves
  module Layers
    module MVC

      def self.included( app )
        
        require 'waves/layers/mvc/extensions'
        require 'waves/layers/mvc/controllers'
        
        app.auto_create_module( :Models ) do
          auto_create_class :Default
          auto_load :Default, :directories => [ :models ]
          auto_create_class true, :Default
          auto_load true, :directories => [ :models ]
        end

        app.auto_create_module( :Views ) do
          auto_create_class :Default, Waves::Views::Base
          auto_load :Default, :directories => [ :views ]
          auto_create_class true, :Default
          auto_load true, :directories => [ :views ]
        end

        app.auto_create_module( :Controllers ) do
          auto_create_class :Default, Waves::Controllers::Base
          auto_load :Default, :directories => [ :controllers ]
          auto_create_class true, :Default
          auto_load true, :directories => [ :controllers ]          
        end

        app.auto_create_module( :Helpers ) do
          auto_create_module( :Default ) { include Waves::Helpers::Extended }
          auto_load :Default, :directories => [ :helpers ]
          auto_create_module( true ) { include app::Helpers::Default }
          auto_load true, :directories => [ :helpers ]
        end
        
      end
    end
  end
end
