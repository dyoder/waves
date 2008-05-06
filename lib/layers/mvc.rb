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
            autocreate_class
            autoload_class
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

        end
      end
    end
  end
end
