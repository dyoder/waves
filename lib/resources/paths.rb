module Waves
  
  module Resources
    
    class Paths
      
      def generate( template, args )
        if template.is_a? Array
          if args.size == 1 and args.first.is_a? Hash
            process_hash( template, args.first )
          else
            process_array( template, args)
          end
        else
          "/#{ args * '/' }"
        end
        
      end
      
      def process_array( template, args )
        path = []
        ( "/#{ path * '/' }" ) if template.all? do | want |
          case want
          when Symbol then path << args.shift
          when String then path << want
          when true then path += args
          when Hash
            key, value = want.to_a.first
            case value
            when true then path += args
            when String, Symbol
              args.empty? ? path << value : path << args.shift
            when Regexp
              component = args.shift.to_s
              raise ArgumentError, "#{component} does not match #{want.inspect}" unless component =~ value
              path << component
            end
          when Regexp
            component = args.shift.to_s
            raise ArgumentError, "#{component} does not match #{want.inspect}" unless component =~ want
            path << component
          end
          
        end
      end
      
      def process_hash( template, hash )
        path = []
        ( "/#{ path * '/' }" ) if template.all? do |want|
          case want
          when Symbol
            raise ArgumentError, "Path generator needs a value for #{want.inspect}" unless component = hash[want]
            path << component
          when String then path << want
          when Hash
            key, value = want.to_a.first
            case value
            when Regexp
              raise ArgumentError, "Path generator needs a value for #{want.inspect}" unless component = hash[key]
              raise ArgumentError, "#{component} does not match #{want.inspect}" unless component =~ value
              path << component
            when String, Symbol
              hash.has_key?(key) ? path << hash[key] : path << value
            when true
              raise ArgumentError, "Path generator needs a value for #{want.inspect}" unless component = hash[key]
              path += [component].flatten
            end
          when Regexp, true
            raise ArgumentError, "Path generator can't take an args hash, as it contains a Regexp or the value true"           
          end
        end
      end
      
    end
  end

end