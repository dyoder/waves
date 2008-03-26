module Test
  module Configurations
    class Development < Default
    
      host '127.0.0.1'

      port 3000

			reloadable [ Test ]

			log :level => :debug	

      application do
				use Rack::ShowExceptions
				run Waves::Dispatchers::Default.new
			end				
			
    end
  end
end


