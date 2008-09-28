module Waves
  
  # Helper methods can be defined for any view template by simply defining them within the default Helper module in <tt>helpers/default.rb</tt> of the generated application. Helpers specific to a particular View class can be explicitly defined by creating a helper module that corresponds to the View class. For examples, for the +User+ View class, you would define a helper module in <tt>user.rb</tt> named +User+.
  #
  # The default helper class initially includes a wide-variety of helpers, including helpers for layouts, Textile formatting, rendering forms, and nested views, as well as helpers for accessing the request and response objects. More helpers will be added in future releases, but in many cases, there is no need to include all of them in your application.
  module Helpers

    # Common helpers are helpers that are needed for just about any Web page. For example,
    # each page will likely have a layout and a doctype.

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
