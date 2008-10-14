
module Waves

  module Caches
    
    #
    # This class is more or less here to establish the basic interface for caching and for
    # lightweight caching that doesn't require a dedicated caching process.
    #
    
    class Simple
      
      def initialize( hash = {} ) ; @cache = hash ; end
      def [](key) ; fetch(key) ; end
      def []=( key, value ) ; store( key, value ) ; end
      def exists?( key ) ; @cache.has_key?( key ) ; end
      alias :exist? :exists?
      def store( key, val ) ; @cache[ key ] = val ; end
      def fetch( keys ) ; @cache[ key ] ; end
      def delete( key ) ; @cache.delete( key ) ; end
      def clear ; @cache = {} ; end
      
    end

  end
end