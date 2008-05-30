module Waves
  module Layers
    module DefaultErrors

      def self.included( app )

        app.instance_eval do

          auto_eval :Configurations do
            auto_eval :Mapping do
              extend Waves::Mapping
              handle(Waves::Dispatchers::NotFoundError) do
                html = Waves.application.views[:errors].process( request ) do
                  not_found_404( :error => Waves::Dispatchers::NotFoundError )
                end
                response.status = '404'
                response.content_type = 'text/html'
                response.body = html
              end
            end
          end

        end
      end
    end
  end
end
