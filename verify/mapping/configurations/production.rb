module Test

  module Configurations
      
    class Production < Default
  
      host '0.0.0.0'

      port 80

  		reloadable []

  		log :level => :error, 
  		  :output => ( :log / "waves.#{$$}" ),
  		  :rotation => :weekly

      application do
  			run Waves::Dispatchers::Default.new
  		end				
		
    end

  end
  
end
