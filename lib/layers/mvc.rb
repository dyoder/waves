module Waves
  module Layers
    module MVC

      def self.included( app )

        app.module_eval do
          include Autocode

          # leave it to the ORM layers to add ORM-specific initializers
          autocreate( :Models, Module.new { include Autocode; autocreate_class; autoload_class })

          autocreate( :Views, Module.new {
            include Autocode; include Waves::Views::Mixin
            autocreate_class; autoload_class
          })

          autocreate( :Controllers, Module.new {
            include Autocode; include Waves::Controllers::Mixin
            autocreate_class; autoload_class
          })

          autocreate( :Helpers, Module.new { include Autocode; autocreate_class; autoload_class })

        end
      end
    end
  end
end
