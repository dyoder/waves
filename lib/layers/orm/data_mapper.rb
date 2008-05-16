# gem 'dm-core'
$:.unshift("/Users/psq/src/datamapper/dm-core-sam/lib")

require 'data_mapper'

module Waves
  module Layers
    module ORM
      
      module DataMapper
        
        def self.included(app)
          
          def app.database
            @adapter ||= ::DataMapper.setup(:main_repository, config.database[:database])
          end
          
          app.instance_eval do
            
            auto_eval :Models do
              auto_load true, :directories => [:models]
            end
             
            auto_eval :Configurations do
              auto_eval :Mapping do
                before :path => /.*/ do
                  ::DataMapper::Repository.context.push(::DataMapper::Repository.new(:main_repository))
                end
                after :path => /.*/ do
                  ::DataMapper::Repository.context.pop
                end
              end
            end
            
          end
        end
        
      end
    end
  end
end
