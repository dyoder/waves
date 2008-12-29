module Waves
  
  module Resources
    
    class Paths
      
      def generate( template, args )
        if template.is_a? Array and not template.empty?
          path = []
          ( "/#{ path * '/' }" ) if template.all? do | want |
            case want
            when true then path += args
            when String then path << want
            when Symbol then path << args.shift
            when Regexp
              component = args.shift.to_s
              raise ArgumentError, "#{component} does not match #{want.inspect}" unless component =~ want
              path << component
            when Hash
              key, value = want.to_a.first
              case value
              when true then path += args
              when String, Symbol
                # if no args to interpolate, use hash element value as default
                !args.empty? ? path << args.shift : path << value
              when Regexp
                component = args.shift.to_s
                raise ArgumentError, "#{component} does not match #{want.inspect}" unless component =~ value
                path << component
              end
            end
          end
        else
          "/#{ args * '/' }"
        end
      end
    end
  end

end