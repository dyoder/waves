module Waves
  module Layers
    module MVC

      def self.included( app )

        app.module_eval do
          include Autocode
                    
          autocreate( :Models, Module.new { 
            include Autocode
            autocreate_class true, Class
            autoload_class true, Class, { :directories => "models"}
          })

          autocreate( :Views, Module.new {
            include Autocode
            include Waves::Views::Mixin 
            autocreate_class true, Class
            autoload_class true, Class, { :directories => "views"}
          })
          
          autocreate( :Controllers, Module.new { 
            include Autocode
            include Waves::Controllers::Mixin 
            autocreate_class true, Class.new
            autoload_class true, Class, { :directories => "controllers"}
          })
          
          autocreate( :Helpers, Module.new { 
            include Autocode
            autocreate_class true, Class
            autoload_class true, Class, { :directories => "helpers"}
            autoinit :Default do 
              attr_reader :request, :content
              include Waves::ResponseMixin
              include Waves::Helpers::Common
              include Waves::Helpers::Formatting
              include Waves::Helpers::Model
              include Waves::Helpers::View
              include Waves::Helpers::Form
            end
          })

        end
      end
    end
  end
end
