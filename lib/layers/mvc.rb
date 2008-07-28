module Waves
  module Layers
    # The MVC layer establishes the Models, Views, Controllers, and Helpers namespaces inside 
    # a Waves application.  In each namespace, undefined constants are handled by AutoCode, which
    # loads the constant from the correct file in the appropriate directory if it exists, or creates
    # from default otherwise.
    module MVC

      def self.included( app )
        
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
          auto_create_module( :Default ) { include Waves::Helpers::Default }
          auto_load :Default, :directories => [ :helpers ]
          auto_create_module( true ) { include app::Helpers::Default }
          auto_load true, :directories => [ :helpers ]
        end
        
        app.auto_eval :Resources do
          auto_create_class :Default, Waves::Resources::Base
          auto_load :Default, :directories => [ :resources ]
          auto_eval :Default do
            def controller ; @controller ||= controllers[ singular ].process( @request ) { self } ; end
            def view ; @view ||= views[ singular ].process( @request ) { self } ; end
            def action( method, *args ) ; @data = controller.send( method, *args ) ; end
            def render( method ) ; view.send( method, ( @data.kind_of?( Enumerable ) ? plural : singular ) => @data ) ; end
            def method_missing( name, *args, &block) ; params[ name.to_s ] ; end
          end
          auto_create_class true, app::Resources::Default
          auto_load true, :directories => [ :resources ]          
        end
        
        lambda {
          string_or_symbol = lambda { |arg| arg.kind_of?(String) || arg.kind_of?(Symbol) }
          Waves::ResponseMixin.module_eval do
            [ :models, :controllers, :views, :helpers ].each do |k|
              functor( k ) { app[ k ] }
              functor( k, string_or_symbol ) { |name| app( name )[ k ] }
            end
          end
        }.call
                  
      end
    end
  end
end
