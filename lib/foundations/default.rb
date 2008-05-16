module Waves
  module Foundations
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

