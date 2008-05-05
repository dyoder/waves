module Waves
  module Foundations
    module Defaul

      def self.included( app )

        app.module_eval do

          include Autocode

          include Waves::Foundations::Simple
          include Waves::Layers::DefaultErrors
          include Waves::Layers::MVC

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

