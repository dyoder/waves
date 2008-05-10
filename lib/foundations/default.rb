require 'layers/orm/sequel'
module Waves
  module Foundations
    module Default

      def self.included( app )

        app.instance_eval do

          include Waves::Layers::Simple
          include Waves::Layers::DefaultErrors
          include Waves::Layers::MVC
          include Waves::Layers::ORM::Sequel

          # Set autoloading from default.rb files
          #autoinit :Configurations do
          #  autoload_class true
          #end
          
        end
        
        Waves << app
        
      end
    end
  end
end

