# require 'layers/rack/rack_cache'
module Blog

  module Configurations

    class Development < Default

      reloadable [ Blog ]
      
      # in case we want to use http caching
      # include Waves::Cache::RackCache
      application.use Rack::Session::Cookie, :key => 'rack.session',
        # :domain => 'foo.com',
        :path => '/',
        :expire_after => 2592000,
        :secret => 'Change it'
      application.use ::Rack::Static, 
          :urls => %w( /css /javascript /favicon.ico ), 
          :root => 'public'

      server Waves::Servers::Mongrel

    end

  end

end
