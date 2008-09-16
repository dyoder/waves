module Waves
  module Layers
    module Cache

      module FileCache
        
        def self.included(app)
          require 'layers/cache/file_cache/filecache-ipi'

          unless Waves.cache.nil?
            Waves.cache = Waves::Layers::Cache::FileCache::IPI.new( Waves.config.cache )
          end
          
        end
      end

    end
  end
end

