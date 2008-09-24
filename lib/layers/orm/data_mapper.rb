module Waves
  module Layers
    module ORM
      
      # Work in Progress
      module DataMapper
        
        def self.included(app)
          gem 'dm-core', '=0.9.0'

          require 'data_mapper'
          
          def app.database
            @adapter ||= ::DataMapper.setup(:main_repository, config.database[:database])
          end
          
          app.auto_eval :Models do
            auto_load true, :directories => [:models]
          end

          app.auto_eval :Configurations do
            auto_eval :Mapping do
              before true do
                app.database #force adapter init if not already done
                ::DataMapper::Repository.context.push(::DataMapper::Repository.new(:main_repository))
              end
              always true do
                ::DataMapper::Repository.context.pop
              end
            end
          end
            
        end
      end
    end
  end
end
