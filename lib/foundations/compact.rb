require 'autocode'
module Waves
  module Foundations
    module Compact
      def self.included( app )
        app.const_set( :Resources, Module.new {
          include AutoCode
          auto_load true
          const_set( :Map, Class.new {
            include Waves::Resources::Mixin
            handler( Waves::Dispatchers::NotFoundError ) do
              response.status = 404; response.content_type = 'text/html'
              Waves::Views::Errors.process( request ) { not_found_404 }
            end
          })
        })
        app.const_set( :Configurations, Module.new {
          const_set( :Development, Class.new( Waves::Configurations::Default ) {
            reloadable [ app::Resources ]
            log :level => :debug
            host '127.0.0.1'
            port 3000
            handler ::Rack::Handler::Mongrel, :Host => host, :Port => port
            application do
              use ::Rack::ShowExceptions
              run ::Waves::Dispatchers::Default.new
            end
            resource app::Resources::Map
          })
          const_set( :Production, Class.new( self::Development ) {
            log :level => :error, :output => ( "log.#{$$}" ), :rotation => :weekly
            port '0.0.0.0'
          })
        })
        Waves << app
      end
    end
  end
end


