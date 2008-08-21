module Blog

  module Configurations

    class Production < Default

      database :adapter => 'sqlite', :database => 'blog.db'

      reloadable []

      log :level => :info,
        :output => ( :log / "waves.production" )

      host '0.0.0.0'

      port 3000

      handler ::Rack::Handler::Mongrel, :Host => host, :Port => port
      # handler ::Rack::Handler::WEBrick, :BindAddress => host, :Port => port
      # handler ::Rack::Handler::Thin, :Host => host, :Port => port

      application do
        use ::Rack::Static, :urls => [ '/css', '/javascript', '/favicon.ico' ], :root => 'public'
        run ::Waves::Dispatchers::Default.new
      end

    end
  end
end
