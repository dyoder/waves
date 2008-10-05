module Waves
  module Layers
    # The MVC layer establishes the Models, Views, Controllers, and Helpers namespaces inside 
    # a Waves application.  In each namespace, undefined constants are handled by AutoCode, which
    # loads the constant from the correct file in the appropriate directory if it exists, or creates
    # from default otherwise.
    module MVC

      def self.included( app )
        require 'controllers/mixin'
        require 'views/mixin'
        require 'views/errors'
        
        Waves::Resources::Mixin.module_eval do
            
          def controller( method = nil, *args, &block )
            @controller ||= app::Controllers[ singular ].process( @request ) { self }
          end

          def view( method = nil, assigns = nil )
            @view ||= app::Views[ singular ].process( @request ) { self }
          end
        
        end
        
        Waves::ResponseMixin.module_eval do 

          # Returns the name of the model corresponding to this controller by taking the basename
          # of the module and converting it to snake case. If the model plurality is different than
          # the controller, this will not, in fact, be the model name.
          def model_name; self.class.basename.snake_case; end

          # Returns the model corresponding to this controller by naively assuming that 
          # +model_name+ must be correct. This allows you to write generic controller methods such as:
          #
          #   model.find( name )
          #
          # to find an instance of a given model. Again, the plurality of the controller and
          # model must be the same for this to work.
          def model; app::Models[ model_name.intern ]; end
          
          # MVC Params get automatically destructured with the keys as accessors methods.
          # You can still access the original query by calling request.query
          def query
            @query ||= Waves::Request::Query.new( 
              Waves::Request::Utilities.destructure( request.query ) )
          end
          
          def attributes
            query[ model_name ]
          end
          
        end
        
        app.auto_create_module( :Models ) do
          include AutoCode
          auto_create_class :Default
          auto_load :Default, :directories => [ :models ]
        end
        
        app.auto_eval( :Models ) do
          auto_create_class true, app::Models::Default
          auto_load true, :directories => [ :models ]
        end

        app.auto_create_module( :Views ) do
          include AutoCode
          auto_create_class :Default, Waves::Views::Base
          auto_load :Default, :directories => [ :views ]
        end
        
        app.auto_eval( :Views ) do
          auto_create_class true, app::Views::Default
          auto_load true, :directories => [ :views ]
        end

        app.auto_create_module( :Controllers ) do
          include AutoCode
          auto_create_class :Default, Waves::Controllers::Base
          auto_load :Default, :directories => [ :controllers ]
        end
        
        app.auto_eval( :Controllers ) do
          auto_create_class true, app::Controllers::Default
          auto_load true, :directories => [ :controllers ]          
        end

        app.auto_create_module( :Helpers ) do
          include AutoCode
          auto_create_module( :Default ) { include Waves::Helpers::Extended }
          auto_load :Default, :directories => [ :helpers ]
          auto_create_module( true ) { include app::Helpers::Default }
          auto_load true, :directories => [ :helpers ]
        end
        
      end
    end
  end
end
