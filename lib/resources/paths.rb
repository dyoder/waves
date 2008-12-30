module Waves
  
  module Resources
    
    class Paths
      
      attr_accessor :compiled
      
      def generate( template, args )
        return "/" if template.empty?
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
        @compiled ||= {}
        template_key = ([template, args.size]).hash
        compiled = @compiled[template_key]
        return ( compiled % args ) if compiled 
        compilable = true
        path = []; cpath, interpolations = "", []
        result = ( cpath % interpolations ) if template.all? do | want |
          case want
          when Symbol
            cpath << "/%s" ; interpolations << args.shift
          when String
            cpath << "/#{want}"
          when true
            compilable = false
            cpath += "/#{args.join("/")}"; args = []
          when Hash
            compilable = false
            key, value = want.to_a.first
            case value
            when true
              cpath += "/#{args.join("/")}"; args = []
            when String, Symbol
              compilable = true
              component = args.shift
              cpath << "/%s"
              component ? interpolations << component : interpolations << value 
            when Regexp
              component = args.shift.to_s
              raise ArgumentError, "#{component} does not match #{want.inspect}" unless component =~ value
              cpath << "/%s"; interpolations << component
            end
          when Regexp
            compilable = false
            component = args.shift.to_s
            raise ArgumentError, "#{component} does not match #{want.inspect}" unless component =~ want
            cpath << "/%s"; interpolations << component
          end
        end
        raise ArgumentError, "Too many args" unless args.empty?
        @compiled[template_key] = cpath if compilable
        result
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