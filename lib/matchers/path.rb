module Waves

  module Matchers
    
    # In a Waves mapping, the Pattern is the structure used to match the path of the request URI.
    # 
    # A Pattern consists of an array where each element corresponds to a path component in a request URI.
    
    class Path < Base
      
      # Takes an array of pattern elements ... coming soon, support for formatted strings!
      def initialize( pattern ) ; @pattern = pattern  ; end
      
      def call( request )
        # TODO: refactor terminating conditions - these work but don't make sense
        return {} if @pattern == true
        path = extract_path( request ).reverse
        return {} if ( @pattern.nil? or @pattern == false or ( path.empty? and @pattern.empty? ) )
        capture = {}
        capture if @pattern.all? do | want |
          case want
          when true then path = []
          when String then want == path.pop
          when Symbol then capture[ want ] = path.pop
          when Regexp then want === path.pop
          when Hash
            key, value = want.to_a.first
            case value
            when true then
              unless path.empty?
                capture[ key ] = path.reverse
                path = []
              end
            when String, Symbol
              got = path.pop
              capture[ key ] = got ? got : value.to_s
            when Regexp then
              got = path.pop
              capture[ key ] = got if value === got
            end
          end
        end
      end

      private 

      # just a little helper method
      def extract_path( request )
        path = request.traits.waves.path
        return path if path
        path = request.path.split('/')
        path.shift unless path.empty?
        request.traits.waves.path = path
      end

    end
    
    
  end

end
