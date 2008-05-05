module Blog
  module Configurations
    class Development < Defaul

      host '127.0.0.1'

      port 3000

      reloadable [ Blog ]

      log :level => :debug

      handler ::Rack::Handler::Mongrel, :Host => host, :Port => por
        # handler ::Rack::Handler::WEBrick, :BindAddress => host, :Port => por
        # handler ::Rack::Handler::Thin, :Host => host, :Port => por

      application do
        use Rack::ShowExceptions
        use Rack::Static, :urls => [ '/css', '/javascript' ], :root => 'public'
        run Waves::Dispatchers::Default.new
      end

    end
  end
end


