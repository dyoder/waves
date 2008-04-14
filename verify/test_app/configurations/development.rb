module TestApp
  module Configurations
    class Development < Default
      
      database :adapter => 'sqlite', :database => 'orm.db'
      
      host '127.0.0.1'
      
      port 3000
      
      reloadable [ TestApp ]
      
      log :level => :debug	
      
      application do
        use Rack::ShowExceptions
        run Waves::Dispatchers::Default.new
      end
      
    end
  end
end
