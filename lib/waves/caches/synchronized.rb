
module Waves

  module Caches
    
    #
    # This is just a proxy for the real cache, but adds Waves synchronization
    #
    
    class Synchronized
      
      def initialize( cache ) ; @cache = cache ; end
      def [](key) ; @cache.fetch(key) ; end
      def []=( key, value ) ; @cache.store( key, value ) ; end
      def exists?( key ) ; @cache.has_key?( key ) ; end
      alias :exist? :exists?
      def store( key, val ) ; synchronize { @cache.store( key, value ) }; end
      def fetch( keys ) ; @cache.fetch( key ) ; end
      def delete( key ) ; synchronize { @cache.delete( key ) } ; end
      def clear ; synchronize { @cache.clear } ; end
      def synchronize( &block ) ; Waves.synchronize( &block ) ; end
    end

  end
end