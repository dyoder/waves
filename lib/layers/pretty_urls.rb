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

          target.module_eval do

            extend Waves::Mapping

            path '/{resource}', :named => :all, :method => :get,
              :action => lambda { | resource | with( resource ).all and render( :list ) }
              
            path '/{resource}/{name}', :named => :get, :method => :get,
              :action => lambda { | resource, name | with( resource ).find( name ) and render( :show ) }
              
            path '/{resource}/{name}/editor', :named => :editor, :method => :get,
              :action => lambda { | resource, name | with( resource ).find( name ) and render( :editor ) }

          end

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

          target.module_eval do

            extend Waves::Mapping

            path '/{resource}', :named => :create, :method => :post do | resource |
              with( resource ).create and redirect( :editor, :resource => resource, :name => instance.name )
            end

            path '/{resource}/{name}', :named => :update, :method => :put do | resource, name |
              with(resource).update( name ) and redirect( :show, :resource => resource, :name => name )
            end

            path '/{resource}/{name}', :named => :delete, :method => :delete,
              :action => lambda { | resource, name | with( resource ).delete( name ) }

          end

        end

      end

    end

  end

end
