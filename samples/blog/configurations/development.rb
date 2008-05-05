module Blog
  module Configurations
    class Development < Default

      host '127.0.0.1'

      port 3000

      reloadable [ Blog ]

      log :level => :debug

      handler ::Rack::Handler::Mongrel, :Host => host, :Port => port
        # handler ::Rack::Handler::WEBrick, :BindAddress => host, :Port => port
        # handler ::Rack::Handler::Thin, :Host => host, :Port => port

      application do
        use Rack::ShowExceptions
        use Rack::Static, :urls => [ '/css', '/javascript' ], :root => 'public'
        run Waves::Dispatchers::Default.new
      end

    end
  end
end


