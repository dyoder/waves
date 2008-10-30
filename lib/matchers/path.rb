module Waves

  module Matchers
    
    class Path < Base
      
      # Takes an array of pattern elements ... coming soon, support for formatted strings!
      def initialize( pattern ) ; @pattern = pattern  ; end
      
      def call( request )
        return {} if @pattern == true or @pattern == false or @pattern.nil?
        path = extract_path( request ).reverse
        return {} if ( path.empty? and @pattern.empty? )
        capture = {}
        match =  @pattern.all? do | want |
          case want
          when true # means 1..-1
            path = [] unless path.empty?
          when Range 
            if want.end == -1
              path = [] if path.length >= want.begin
            else
              path = [] if want.include? path.length
            end
          when String then want == path.pop
          when Symbol then capture[ want ] = path.pop
          when Regexp then want === path.pop
          when Hash
            key, value = want.to_a.first
            case value
            when true
              ( capture[ key ], path = path.reverse, [] ) unless path.empty?
            when Range
              if value.end == -1
                ( capture[ key ], path = path.reverse, [] ) if path.length >= value.begin
              else
                ( capture[ key ], path = path.reverse, [] ) if value.include? path.length
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
        capture if match && path.empty?
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
