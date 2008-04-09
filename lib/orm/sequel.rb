require 'sequel'

module Waves
  module Orm
    
    Model = ::Sequel::Model
    
    module Sequel
      
      def self.included(mod)
        
        mod.instance_eval do
          def sequel ; @sequel ||= ::Sequel.open( config.database ) ; end
          def orm ; @orm ||= sequel ; end
          def model_config(context, name); context.set_dataset(orm[ name ]); end
        end
        
      end
    end
  end
end
