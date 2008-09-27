module Waves
  
  module Resources
    
    class Paths
      
      attr_accessor :request
      
      include Waves::ResponseMixin
      
      def initialize( request ) ; @request = request ; end
      
      def generate( template, args )
        return "/#{ args * '/' }" unless template.is_a?( Array ) and not template.empty?
        path = []
        ( "/#{ path * '/' }" ) if template.all? do | want |
          case want
          when true then path += args
          when String then path << want
          when Symbol then path << args.shift
          when Regexp then path << args.shift
          when Hash
            key, value = want.to_a.first
            case value
            when true then path += args
            when String, Symbol, RegExp then path << args.unshift
            end
          end
        end
      end
    end
  end

end