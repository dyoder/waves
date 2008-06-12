module Waves
  
  # A Waves Foundation provides just enough functionality to allow a Waves application
  # to run.  Typically, a Foundation will include several Layers, perform any necessary
  # configuration, and register the application with the Waves module
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

