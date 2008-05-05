module Waves
  module Helpers

    # View helpers are intended to help reuse views from within other views.
    # Both the +layout+ method in the common helpers and the +property+ method
    # of the form helpers are specialized instance of this.
    #
    # The star of our show here is the +view+ method. This takes a model, view,
    # and assigns hash (which are converted into instance variables in the target
    # view) and returns the result of evaluating the view as content in the current
    # template.
    module View

      # Invokes the view for the given model, passing the assigns as instance variables.
      def view( model, view, assigns = {} )
        self << Waves.application.views[ model ].process( request ) do
          send( view, assigns )
        end
      end


    end
  end
end
