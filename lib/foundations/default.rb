require 'sequel'

module Waves
  module Foundations
    module Default
      
      def self.included( app )
        
        app.module_eval do
          extend Autocode; extend Reloadable
          
          include Waves::Foundations::Simple
          # autocreate( :Configurations, Module.new {
          #   extend Autocode
          #   autocreate( :Development, Class.new( Waves::Configurations::Default ))
          #   autocreate( :Mapping, Module.new { |mod| extend Waves::Mapping })
          # })
          # autocreate( :Models, Module.new )
          # autocreate( :Views, Module.new { include Waves::Views::Mixin })
          # autocreate( :Controllers, Module.new { include Waves::Controllers::Mixin })
          # autocreate( :Helpers, Module.new {  })
          
          # autoload true, :type => Module, :directories => :lib
          
          # [ :Configurations, :Models, :Views, :Controllers, :Helpers ].each do | name |
          #   autocreate( name, Module.new ) do
          # 
          #     # dynamically access module constants
          #     def self.[]( cname )
          #       eval("#{name}::#{cname.to_s.camel_case}")
          #     end

          	  # first try to load and only create if that fails
          	  # which means install autoload *after* autocreate
              # extend Autocode

          	  # autoload any files in appropriately named directories
          	  autoinit :Configurations do
                autoload true, :exemplar => Class.new(app.configurations["Default"]), :directories => :configurations
                autoload :Mapping, :exemplar => Module.new, :directories => :configurations
          	  end
          	  
          	  autoinit :Helpers do
          	    autoload true, :exemplar => app.helpers["Default"], :directories => :helpers
          	  end
          	  
          	  autoinit :Models do
          	    extend Autocode
                autoload true, :exemplar => Class.new(Sequel::Model), :directories => :models
                autocreate true, app.models["Default"] do
                  set_dataset app.database[ basename.snake_case.plural.intern]
                end
          	  end
          	  
              autoinit :Views do
                extend Autocode
                autoload true, :exemplar => Class.new(app.views["Default"]), :directories => :views
                autocreate true, app::Views::Default
              end
              
              autoinit :Controllers do
                autoload true, :exemplar => Class.new(app.controllers["Default"]), :directories => :controllers
                autocreate true, app::Controllers::Default
              end
          	  

              # # autocreate declarations ...
              # case name
              #               # don't autocreate configs
              #               when :Configurations then nil
              #               # set the dataset for Models
              #               when :Models
              #   autocreate true, app.models['Default'] do
              #     set_dataset app.database[ basename.snake_case.plural.intern ]
              #   end
              # # everything else just use the exemplar
              # else
              #   autocreate true, app.send( name.to_s.snake_case )::Default
              # end

            # end

          # end

          # accessor methods for modules and other key application objects ...
          class << self
            # def config ; Waves.config ; end
            def database ; @database ||= Sequel.open( config.database ) ; end
            # def configurations ; self::Configurations ; end
            # def controllers ; self::Controllers ; end
            # def models ; self::Models ; end
            # def helpers ; self::Helpers ; end
            # def views ; self::Views ; end
          end
        	
          # include Waves::Layers::DefaultErrors
        	
        end
      end
    end
  end
end

