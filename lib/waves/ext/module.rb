module Waves
  module Ext
    module Module

      def basename ; self.name.split('::').last || '' ; end
      def rootname ; self.name.split('::').first ; end
      def root ; eval( "::#{self.rootname}" ) ; end

      # Just a convenience method for dynamically referencing submodules. Note that
      # you cannot do const_get, because that will also attempt to deref the cname
      # at global scope. So it is more efficient to just use eval.
      def []( cname ) ; eval( "self::#{cname.to_s.camel_case}" ) ; end
      
    end
  end  
end

class Module # :nodoc:
  include Waves::Ext::Module
end