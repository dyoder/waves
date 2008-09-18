module Waves
  
  module Resources
    
    class Paths
      
      include Functor::Method
      
      # TODO: path generation is broken ...
      # def self.define_path( name, path_array )
      #  define_method( name ) { |*args| nil } # generate( path_array, args ) }
      # end
      
      def initialize( request )
        # @request = request ; @resource = ( resource or blackboard.waves.resource.basename.snake_case.to_s )
      end

      # functor( :generate, Array, Array ) do | keys, vals |
      #   prefix = Waves.config.resources.call( @resource, @request.blackboard.waves.mount ) rescue nil
      #   ( keys = prefix  + keys ) if prefix
      #   path = '/' << keys.map { |key| generate( key, vals ) }.compact.join('/')
      #   ( path << "?" << vals.first.map { |k,v| "#{k}=#{v}" }.join("&") ) if vals.first.respond_to?( :keys )
      #   return path
      # end
      # functor( :generate, :resource, Array ) { | key, vals | @resource.singular }
      # functor( :generate, :resources, Array ) { | key, vals | @resource.plural }
      # 
      # functor( :generate, Symbol, Array ) { | key, vals | generate( vals.shift ) }
      # functor( :generate, String, Array ) { | string, vals | string }
      # functor( :generate, Regexp, Array ) { | key, vals | generate( vals.shift ) }
      # 
      # functor( :generate, Object ) { | val | val.to_s }
      # 
      # functor( :generate, Hash, Array ) { | h, vals | k, v = h.to_a.first ; generate( k, v, vals ) }
      # functor( :generate, :resource, Object, Array ) { | key, val, args | @resource.singular }
      # functor( :generate, :resources, Object, Array ) { | key, val, args | @resource.plural }
      # functor( :generate, Symbol, Object, Array ) { | key, val, args | args.shift or val.to_s }
      
    end
    
  end

end