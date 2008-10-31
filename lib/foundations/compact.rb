module Waves
  module Foundations
    module Compact
      def self.included( app )
        app.module_eval {
          const_set( :Resources, Module.new {
            const_set( :Map, Class.new { 
              include Waves::Resources::Mixin
              handler( Waves::Dispatchers::NotFoundError ) {
                response.status = 404; response.content_type = 'text/html'
                Waves::Views::Errors.new( request ).not_found_404
              }
            })
          })
          const_set( :Configurations, Module.new {
            const_set( :Development, Class.new( Waves::Configurations::Default ) {
              log :level => :debug
              host '127.0.0.1'
              port 3000
              server Waves::Servers::Mongrel
              resource app::Resources::Map
            })
            const_set( :Production, Class.new( self::Development ) {
              log :level => :error, :output => ( "log.#{$$}" ), :rotation => :weekly
              port 80
              host '0.0.0.0'
              server Waves::Servers::Mongrel
              application {
                use Rack::Session::Cookie, :key => 'rack.session',
                  # :domain => 'foo.com',
                  :path => '/',
                  :expire_after => 2592000,
                  :secret => 'Change it'

                run ::Waves::Dispatchers::Default.new
              }
              
            })
          })
        }
        Waves << app
      end
    end
  end
end


