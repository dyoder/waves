module Waves
  module Layers
    module SimpleErrors

      def self.included( app )

        app.module_eval do

          autoinit 'Configurations::Mapping' do
            handle(Waves::Dispatchers::NotFoundError) { response.status = 404 }
          end

        end
      end
    end
  end
end
