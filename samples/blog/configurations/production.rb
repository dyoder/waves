module Blog

  module Configurations

    class Production < Defaul

      host '0.0.0.0'

      port 80

      reloadable []

      log :level => :error,
        :output => ( :log / "waves.#{$$}" ),
        :rotation => :weekly

      handler ::Rack::Handler::Mongrel, :Host => host, :Port => por
        # handler ::Rack::Handler::WEBrick, :BindAddress => host, :Port => por
        # handler ::Rack::Handler::Thin, :Host => host, :Port => por

      application do
        run Waves::Dispatchers::Default.new
      end

    end

  end

end
