require 'erubis'

module Erubis

  # This is added to the Erubis Content class to allow the same helper methods
  # to be used with both Markaby and Erubis.
  class Context
    include Waves::Helpers::UrlHelper
    include Waves::Helpers::TagHelper
    include Waves::Helpers::AssetHelper
    include Waves::Helpers::NumberHelper
    
    def <<(s) 
      eval("_buf", @binding).concat s # add to rendered output
    end
    
    def capture
      eval("_context.push(_buf); _buf = ''", @binding) #ignore output from that eval, will be added via "<<"
      result = Erubis::Eruby.new(yield).result @binding
      eval("_buf = _context.pop", @binding)
      result
    end
    
    def render(eruby)
      unless @binding
        @binding = binding
        eval("_buf = ''; _context = []", @binding)
      end
      eruby.result @binding
    end

  end

end

module Waves

  module Renderers

    class Erubis

      include Renderers::Mixin

      extension :erb

      def self.render( path, assigns )
        eruby = ::Erubis::Eruby.new( template( path ) )
        helper = helper( path )
        context = ::Erubis::Context.new
        context.meta_eval { include( helper ) ; }
        context.instance_eval do
          assigns.each do |key,val|
            instance_variable_set("@#{key}",val)
          end
        end
        context.render(eruby)
      end

    end

  end

end
