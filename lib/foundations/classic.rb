module Waves
  module Foundations
# The Default foundation supports the common MVC development pattern, a la Rails and Merb. Models, controllers, views, templates, and helpers live in the corresponding directories. When your code calls for a specific M, V, C, or H, Waves tries to load it from a file matching the snake-case of the constant name.  If the file does not exist, Waves creates the constant from a sensible (and customizable) default.
#
# This foundation does not include any ORM configuration.  You can include Waves::Layers::ORM::Sequel or custom configure your model.

    
    module Classic

      def self.included( app )

        require 'autocode'
        require 'layers/mvc'
        require 'layers/inflect/english'
        require 'helpers/extended'
        require 'layers/renderers/markaby'
        require 'layers/renderers/erubis'
        require 'layers/renderers/haml'
        require 'layers/default_errors'
        
        app.module_eval do

          include AutoCode
          
          app.auto_create_module( :Configurations ) do
            include AutoCode
            auto_create_class :Default
            auto_load :Default, :directories => [ :configurations ]
          end

          app.auto_eval( :Configurations ) do
            auto_create_class true, app::Configurations::Default
            auto_load true, :directories => [ :configurations ]
          end

          app.auto_create_module( :Resources ) do
            include AutoCode
            auto_create_class :Default
            auto_load :Default, :directories => [ :resources ]
          end

          app.auto_eval( :Resources ) do
            auto_create_class true, app::Resources::Default
            auto_load true, :directories => [ :resources ]
            auto_eval :Map do
              handler( Waves::Dispatchers::NotFoundError ) {
                response.status = 404; response.content_type = 'text/html'
                app::Views::Errors.process( request ) { not_found_404 }
              }
            end
          end

          include Waves::Layers::Inflect::English
          include Waves::Layers::MVC
          include Waves::Layers::DefaultErrors
          
          include Waves::Renderers::Markaby
          include Waves::Renderers::Erubis   

          
        end
        
        Waves << app
        
      end
    end
  end
end


