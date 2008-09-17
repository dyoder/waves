#--
# Waves::Layers::Cache::MemcachedCache
# File: lib/layers/cache/memcached.rb
#++
# Framework layer to access your memcached server(s). The specific gem we use is 'memcached'.
# We basically stay out of the way, so check 'http://blog.evanweaver.com/files/doc/fauna/memcached/classes/Memcached.html'
# for precise uses.

module Waves
  module Layers
    module Cache

      module Memcached
        
        def self.included(app)
          require 'layers/cache/memcached/memcached-ipi'
          
          if Waves.cache.nil?
            Waves.cache = Waves::Cache::Memcached.new( Waves.config.cache )
          end
          
        end

      end
    end
  end
end