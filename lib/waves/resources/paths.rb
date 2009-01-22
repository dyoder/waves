module Waves
  
  module Resources
    
    class Paths
      
      def self.compiled; @compiled ||= {} ; end
      
      def compiled_paths; self.class.compiled ; end
      
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
        template_key = template
        compiled = compiled_paths[template_key]
        if compiled
          return ( compiled % args ) rescue raise [template, args].inspect
        end
        compilable = true
        cpath, interpolations = "", []
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
        compiled_paths[template_key] = cpath if compilable
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
      
      def original_generate( template, args )
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