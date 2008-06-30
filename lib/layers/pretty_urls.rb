# TODO: Re-implement as a true layer ...

module Waves
  module Mapping

    # A set of pre-packed mapping rules for dealing with pretty URLs (that use names instead
    # of numbers to identify resources). There are two modules.
    # - GetRules, which defines all the GET methods for dealing with named resources
    # - RestRules, which defines add, update, and delete rules using a REST style interface
    #
    module PrettyUrls

      #
      # GetRules defines the following URL conventions:
      #
      #   /resources            # => get a list of all instances of resource
      #   /resource/name        # => get a specific instance of resource with the given name
      #   /resource/name/editor # => display an edit page for the given resource
      #
      module GetRules

        def self.included(target)
          target.action( :list, :get => [ :resources ] ) { action( :all ) and render( :list ) }
          target.action( :read, :get => [ :resource, :name, { :mode => 'show' } ] ) { action( :find, name ) and render( mode ) }
        end

      end

      #
      # RestRules defines the following URL conventions:
      #
      #   POST /resources            # => add a new resource
      #   PUT  /resource/name        # => update the given resource
      #   DELETE /resource/name      # => delete the given resource
      #
      module RestRules

        def self.included(target)
          target.action( :create, :post => [ :resources ] ) { redirect( paths.read( action( :create ).name, 'edit' ) ) }
          target.action( :update, :put => [ :resource, :name ] ) { action( :update, name ) and redirect( paths.read( name ) ) }
          target.action( :delete, :delete => [ :resource, :name ] ) { action( :delete, name ) }
        end

      end

    end

  end

end
