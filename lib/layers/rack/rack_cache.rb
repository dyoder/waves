require 'rack/cache'

module Waves
  
  module Cache

    module RackCache
      
      def self.included(app)
        
        #registering the default configuration for rack-cache
          app.application.use Rack::Cache do
            #set cache related options
            set :verbose,     true
            # default_ttl will be add to any cacheable response without explicit indication of max-age.
            set :default_ttl, 60 * 60 * 24
            # store can be heap, memcache or disk. Default option is heap.
            #set :metastore,   'file:/var/cache/rack/meta'
            set :entitystore, 'file:./cache/rack/body'
            # request containing 'Authorization' and 'Cookie' headers are defined 'private' and thus not cacheable.
            # overriding the private_headers will define which headers make the request not cacheable.
            # instead of overriding this config, you may choose to use the header 'Vary' in your application.
            # set :private_headers, ['Authorization']
          end
        
      end
      
    end
  
  end

end