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
            autoload_class
            autoload_module :Mapping
          end

        end
      end
    end
  end
end

