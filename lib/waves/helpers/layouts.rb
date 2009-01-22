module Waves
  
  module Helpers

    module Layouts

      # Invokes a layout view (i.e., a view from the layouts template directory), using
      # the assigns parameter to define instance variables for the view. The block is
      # evaluated and also passed into the view as the +layout_content+ instance variable.
      #
      # You can define a layout just by creating a template and then calling the
      # +layout_content+ accessor when you want to embed the caller's content.
      #
      # == Example
      #
      #   doctype :html4_transitional
      #   html do
      #     title @title # passed as an assigns parameter
      #   end
      #   body do
      #     layout_content
      #   end
      #
      def layout( name, assigns = {}, &block )
        assigns[ :layout_content ] = capture(&block)
        self << Waves.main::Views[:layouts].process( request ) do
          send( name, assigns )
        end
      end
      
      def layout_content
        self << @layout_content
      end

    end
  end
end
