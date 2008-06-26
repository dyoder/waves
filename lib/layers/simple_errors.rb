module Waves
  module Layers
    # Configures Waves for minimal exception handling.  
    # 
    # For example,
    # a NotFoundError results in response status of 404, with body text
    # of "404 Not Found".
    module SimpleErrors

      def self.included( app )

        app.auto_eval :Configurations do
          auto_eval :Mapping do
            handle(Waves::Dispatchers::NotFoundError) do
               response.status = 404; response.body = "404 Not Found"
            end
          end
        end

      end
    end
  end
end
