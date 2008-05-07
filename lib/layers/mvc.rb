module Waves
  module Layers
    module MVC

      def self.included( app )

        app.module_eval do
          include Autocode

          autocreate( :Models, Module.new) do
            include Autocode
            autocreate_class
            autoload_class
          end

          autocreate( :Views, Module.new) do
            include Autocode
            include Waves::Views::Mixin
            autocreate_class
            autoload_class
          end

          autocreate( :Controllers, Module.new) do
            include Autocode
            include Waves::Controllers::Mixin
            autocreate_class
            autoload_class
          end

          autocreate( :Helpers, Module.new) do
            include Autocode
            autocreate_module
            autoload_module
            autoinit :Default do
              attr_reader :request, :content
              include Waves::ResponseMixin
              include Waves::Helpers::Common
              include Waves::Helpers::Formatting
              include Waves::Helpers::Model
              include Waves::Helpers::View
              include Waves::Helpers::Form
            end
          end
          
          meta_def( :models ) { self::Models }
          meta_def( :views ) { self::Views }
          meta_def( :controllers ) { self::Controllers }
          meta_def( :helpers ) { self::Helpers }

        end
      end
    end
  end
end
