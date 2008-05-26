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

            path '/{model}', :named => :all, :method => :get, :action => all_and_list

            path '/{model}/{name}', :named => :get, :action => find_and_show, :method => :get

            path '/{model}/{name}/editor', :named => :editor, :action => find_editor, :method => :get

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

            path '/{model}', :named => :create, :method => :post do |model|
              redirect( named.editor( :model => model, :name => controllers[model].create.name ) )
            end

            path '/{model}/{name}', :named => :update, :action => update_and_redirect, :method => :put

            path '/{model}/{name}', :named => :delete, :action => delete, :method => :delete

          end

        end

      end

    end

  end

end
