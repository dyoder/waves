module Waves
  
  module Resources
    
    module Mixin
      
      attr_reader :request

      include ResponseMixin

      def initialize(request); @request = request; end
      
    end
      
    # :)
    const_set( :Base, Class.new ).module_eval { include Mixin }  

  end


end
