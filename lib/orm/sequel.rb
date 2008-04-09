require 'sequel'

if defined?(Rake)
  require File.dirname(__FILE__) / :sequel / :tasks / :schema
end

module Waves
  module Orm
    
    Model = ::Sequel::Model
    
    module Sequel
      
      def self.included(mod)
        
        mod.instance_eval do
          def sequel ; @sequel ||= ::Sequel.open( config.database ) ; end
          def database ; @database ||= sequel ; end
          def model_config(context, name); context.set_dataset(database[ name ]); end
        end
        
      end
    end
  end
end
