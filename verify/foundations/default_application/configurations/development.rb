module DefaultApplication
  module Configurations
    class Development

      database :host => 'localhost', :adapter => 'sqlite', :database => 'defaultapplication',
        :user => 'root', :password => ''

      reloadable [ DefaultApplication ]

      log :level => :debug

      host '127.0.0.1'

      port 3000

    handler ::Rack::Handler::Mongrel, :Host => host, :Port => port
      # handler ::Rack::Handler::WEBrick, :BindAddress => host, :Port => port
      # handler ::Rack::Handler::Thin, :Host => host, :Port => port

      application do
        use ::Rack::ShowExceptions
        run ::Waves::Dispatchers::Default.new
      end

    end
  end
end
