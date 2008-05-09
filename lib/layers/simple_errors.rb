module Waves
  module Layers
    module SimpleErrors

      def self.included( app )

        app.instance_eval do

          autoinit 'Configurations::Mapping' do
            handle(Waves::Dispatchers::NotFoundError) { response.status = 404; response.body = "404 Not Found" }
          end

        end
      end
    end
  end
end
