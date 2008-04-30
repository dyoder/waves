module Waves
  module Layers
    module DefaultErrors
      
      def self.included( app )
        
        app.module_eval do
          
          autoinit 'Configurations::Mapping' do
            handle(Waves::Dispatchers::NotFoundError) do
              html = Waves.application.views[:errors].process( request ) do
                not_found_404( :error => Waves::Dispatchers::NotFoundError ) 
              end
              response.status = '404'
              response.content_type = 'text/html'
              response.write( html )
            end
          end
        	
        end
      end
    end
  end
end
