module Blog
  module Configurations
    class Development < Default
    
      host '127.0.0.1'

      port 3000

			reloadable [ Blog ]

			log :level => :debug	

      application do
				use Rack::ShowExceptions
        use Rack::Static, :urls => [ '/css', '/javascript' ], :root => 'public'
				run Waves::Dispatchers::Default.new
			end				
			
    end
  end
end


