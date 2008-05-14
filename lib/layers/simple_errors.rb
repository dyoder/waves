module Waves
  module Layers
    module SimpleErrors

      def self.included( app )

        app.instance_eval do

          auto_eval :Configurations do
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
end
