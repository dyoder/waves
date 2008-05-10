module Waves
  module Layers
    module Simple
      def self.included(app)
        app.instance_eval do

          include Autocode
          autocreate( :Configurations, Module.new) do
            include Autocode
            autocreate true, Waves::Configurations::Default
            autocreate( :Mapping, Module.new) { extend Waves::Mapping }
          end
          meta_def( :config ) { Waves.config }
          meta_def( :configurations ) { self::Configurations }

          include Waves::Layers::SimpleErrors

        end
      end
    end
  end
end
      