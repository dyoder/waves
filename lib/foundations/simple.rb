module Waves
  module Foundations

    module Simple

      def self.included( app )

        app.instance_eval do
          include Waves::Layers::Simple
        end
        
        Waves << app
      end
    end
  end
end

