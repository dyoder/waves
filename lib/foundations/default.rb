require 'layers/orm/sequel'
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
            autoload true
          end
          
          autoinit :Controllers do
            autocreate true, Waves::Controllers::Base
            autoload true
          end
          
          autoinit :Views do
            autocreate true, Waves::Views::Base
            autoload true
          end

        end
      end
    end
  end
end

