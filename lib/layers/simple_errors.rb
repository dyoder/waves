module Waves
  module Layers
    module SimpleErrors

      def self.included( app )

        app.instance_eval do

          autoinit :Configurations do
            autoinit :Mapping do
              handle(Waves::Dispatchers::NotFoundError) { response.status = 404 }
            end
          end

        end
      end
    end
  end
end
