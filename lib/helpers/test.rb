module Waves
  module Helpers
    module Test
      include ::Waves::Helpers::Request
      
      def mapping
        ::Waves::Application.instance.mapping
      end

      def path(*args,&block)
        mapping.path(*args,&block)
      end
  
      def url(*args,&block)
        mapping.url(*args,&block)
      end
 
    end
  end
end