module Waves
  module Layers
    module ORM
      
      # The Filebase ORM layer configures model classes to use Filebase with a datastore located in
      # <tt>db/model_name</tt>, where @model_name@ is the snakecased version of the class name.
      #
      # The Filebase store for Blog::Models::Entry would be located in <tt>db/entry</tt>, for example.
      module Filebase
        
        def self.included(app)
          app.module_eval do
            auto_eval( :Models ) do
              auto_eval( true ) { include ::Filebase::Model[ :db / self.basename.snake_case ] }
            end
          end
        end
        
      end
    
    end
    
  end
  
end