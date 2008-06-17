module Waves
  module Controllers
    class Base

      include Waves::Controllers::Mixin

      def attributes; params[model_name.singular.intern]; end

    end
  end
end