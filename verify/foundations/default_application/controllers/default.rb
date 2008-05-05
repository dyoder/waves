module DefaultApplication

  module Controllers

    class Default

      include Waves::Controllers::Mixin

      def attributes; params[model_name.singular.intern]; end

      def all; model.all; end

      def find( name ); model[ :name => name ] or not_found; end

      def create; model.create( attributes ); end

      def update( name )
        instance = find( name )
        instance.set( attributes )
        instance.save_changes
      end

      def delete( name ); find( name ).destroy; end

    end

  end

end
