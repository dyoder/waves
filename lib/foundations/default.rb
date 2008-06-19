module Waves
  module Foundations
# The Default foundation supports the common MVC development pattern, a la Rails and Merb. Models, controllers, views, templates, and helpers live in the corresponding directories. When your code calls for a specific M, V, C, or H, Waves tries to load it from a file matching the snake-case of the constant name.  If the file does not exist, Waves creates the constant from a sensible (and customizable) default.
#
# This foundation does not include any ORM configuration.  You can include Waves::Layers::ORM::Sequel or custom configure your model.

    
    module Default

      def self.included( app )

        app.instance_eval do

          include Waves::Layers::Simple
          include Waves::Layers::MVC          
          include Waves::Layers::DefaultErrors
          
        end
        
        Waves << app
        
      end
    end
  end
end

