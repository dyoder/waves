module Blog

  module Configurations

    class Production < Default
      
      debug false
      reloadable []
      log :level => :warn, :output => ( :log / "waves.production" )
      host '0.0.0.0'
      port 4000

      application do
        use ::Rack::Static, 
          :urls => %w( /css /javascript /favicon.ico ), 
          :root => 'public'
        use Rack::Session::Cookie, 
          :key => 'blog.session', :path => '/',
          :expire_after => 3.days
        run ::Waves::Dispatchers::Default.new
      end
      

    end
  end
end
