module Blog

  module Configurations

    class Production < Default

      host '0.0.0.0'

      port 80

      reloadable []

      log :level => :error,
        :output => ( :log / "waves.#{$$}" ),
        :rotation => :weekly

      handler ::Rack::Handler::Mongrel, :Host => host, :Port => port
        # handler ::Rack::Handler::WEBrick, :BindAddress => host, :Port => port
        # handler ::Rack::Handler::Thin, :Host => host, :Port => port

      application do
        run Waves::Dispatchers::Default.new
      end

    end

  end

end
