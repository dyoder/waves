module Waves
  
  # A Waves Foundation provides enough functionality to allow a Waves application
  # to run.  At the bare minimum, this means creating configuration classes in the Configurations
  # namespace, as is done in the Simple foundation
  #
  # Typically, a Foundation will include several Layers, perform any necessary
  # configuration, and register the application with the Waves module
  module Foundations

    # The Simple foundation provides the bare minimum needed to run a Waves application.
    # It is intended for use as the basis of more fully-featured foundations, but you can
    # use it as a standalone where all the request processing is done directly in a 
    # mapping lambda.
    module Simple

      # On inclusion in a module, the Simple foundation includes Waves::Layers::Simple and 
      # registers the module as a Waves application.
      def self.included( app )

        app.instance_eval do
          include Waves::Layers::Simple
        end
        
        Waves << app
      end
    end
  end
end

