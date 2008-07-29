module Waves
  
  module Mapping
    
    class Paths
      
      include Functor::Method

      def initialize( resource ) ; @resource = resource ; end

      functor( :generate, Array, Array ) { | keys, vals | '/' + keys.map { |key| generate( key, vals ) }.compact.join('/') }
      functor( :generate, :resource, Array ) { | key, vals | @resource.singular }
      functor( :generate, :resources, Array ) { | key, vals | @resource.plural }

      functor( :generate, Symbol, Array ) { | key, vals | generate( vals.shift ) }
      functor( :generate, Regexp, Array ) { | key, vals | generate( vals.shift ) }

      functor( :generate, Object ) { | val | val.to_s }

      functor( :generate, Hash, Array ) { | h, vals | vals.shift or h.values.first }
      
    end
    
  end

end