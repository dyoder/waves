module Waves
  
  module Mapping
    
    class Paths
      
      include Functor::Method
      
      def self.define_path(name, path_array)
        define_method( name ) { |*args| generate( path_array, args ) }
      end

      def initialize( resource ) ; @resource = resource ; end

      functor( :generate, Array, Array ) do | keys, vals |
        path = '/' << keys.map { |key| generate( key, vals ) }.compact.join('/')
        path << "?" << vals.first.map { |k,v| "#{k}=#{v}" }.join("&") if vals.first.respond_to?( :keys )
        path
      end
      functor( :generate, :resource, Array ) { | key, vals | @resource.singular }
      functor( :generate, :resources, Array ) { | key, vals | @resource.plural }

      functor( :generate, Symbol, Array ) { | key, vals | generate( vals.shift ) }
      functor( :generate, String, Array ) { | string, vals | string }
      functor( :generate, Regexp, Array ) { | key, vals | generate( vals.shift ) }

      functor( :generate, Object ) { | val | val.to_s }

      functor( :generate, Hash, Array ) { | h, vals | k, v = h.to_a.first ; generate( k, v, vals ) }
      functor( :generate, :resource, Object, Array ) { | key, val, args | @resource.singular }
      functor( :generate, :resources, Object, Array ) { | key, val, args | @resource.plural }
      functor( :generate, Symbol, Object, Array ) { | key, val, args | args.shift or val.to_s }
      
    end
    
  end

end