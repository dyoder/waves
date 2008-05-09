module Waves
  module Foundations
    module Default

      def self.included( app )

        app.instance_eval do

          include Autocode

          include Waves::Foundations::Simple
          include Waves::Layers::DefaultErrors
          include Waves::Layers::MVC
          include Waves::Layers::ORM::Sequel
          
          # Set autoloading from default.rb files
          autoinit :Configurations do
            autocreate true, Waves::Configurations::Default
            autoload true, :exemplar => Waves::Configurations::Default
            autoload_module :Mapping
          end
          
          autoinit :Controllers do
            autocreate true, Waves::Controllers::Base
            autoload true, :exemplar => Waves::Controllers::Base
          end
          
          autoinit :Views do
            autocreate true, Waves::Views::Base
            autoload true, :exemplar => Waves::Views::Base
          end

        end
      end
    end
  end
end

