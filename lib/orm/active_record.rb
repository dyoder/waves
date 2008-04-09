class Symbol
  alias :extensions_to_proc :to_proc
  remove_method :to_proc
end
require 'active_record'

if defined?(Rake)
  require File.dirname(__FILE__) / :active_record / :tasks / :schema
end

module Waves
  module Orm
    
    Model = ::ActiveRecord::Base
    
    module ActiveRecord
      
      def self.included(mod)
        
        mod.instance_eval do
          def active_record
            unless @active_record
              ::ActiveRecord::Base.establish_connection(config.database)
              @active_record = ::ActiveRecord::Base.connection
            end
            @active_record
          end
          
          def database
            @database ||= active_record
          end
          
          def model_config(context, name)
            active_record
            context.set_table_name(name)
          end
        end
        
      end
    end
  end
end
