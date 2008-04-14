module TestApp

  module Configurations
      
    class Production < Default
      
      database :host => 'localhost', :adapter => 'mysql', :database => 'testapp',
        :user => 'root', :password => ''
      
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
