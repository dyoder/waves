module Waves
  module Layers
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
            auto_create_class true, Waves::Layers::ORM::Model
            auto_load true, :directories => [:models]
          end

          auto_create_module( :Views ) do
            include AutoCode
            auto_create_class true, Waves::Views::Base
            auto_load true, :directories => [:views]
          end

          auto_create_module( :Controllers ) do
            include AutoCode
            auto_create_class true, Waves::Controllers::Base
            auto_load true, :directories => [:controllers]
          end

          auto_create_module( :Helpers ) do
            include AutoCode
            auto_create_module { include Waves::Helpers::Default }
            auto_load true, :directories => [:helpers]
          end          

        end
      end
    end
  end
end
