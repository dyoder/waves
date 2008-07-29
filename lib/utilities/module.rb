module Waves
  module Utilities
    module Module
      # This comes in handy when you are trying to do meta-programming with modules / classes
      # that may be nested within other modules / classes. I think I've seen it defined in
      # facets, but I'm not relying on facets just for this one method.
      def basename
        self.name.split('::').last || ''
      end
      
      def rootname
        self.name.split('::').first
      end
      
      def root_constant
        eval(  "::#{self.rootname}" )
      end

      # Just a convenience method for accessing a const within a Module
      def []( cname )
        eval( "self::#{cname.to_s.camel_case}" )
      end
    end
  end  
end

class Module # :nodoc:
  include Waves::Utilities::Module
end