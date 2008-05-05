module Waves
  module Helpers

    # Common helpers are helpers that are needed for just about any Web page. For example,
    # each page will likely have a layout and a doctype.

    module Common

      DOCTYPES = {
        :html3 => "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 3.2//EN\">\n",
        :html4_transitional =>
          "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" " <<
           "\"http://www.w3.org/TR/html4/loose.dtd\">\n",
        :html4_strict =>
          "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" " <<
            "\"http://www.w3.org/TR/html4/strict.dtd\">\n",
        :html4_frameset =>
          "<!DOCTYPE html PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" " <<
            "\"http://www.w3.org/TR/html4/frameset.dtd\">\n",
        :xhtml1_transitional =>
          "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" " <<
            "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">\n",
        :xhtml1_strict =>
          "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" " <<
            "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">\n",
        :xhtml1_frameset =>
          "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Frameset//EN\" " <<
            "\"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\">\n",
        :xhtml2 => "<!DOCTYPE HTML PUBLIC \"-//IETF//DTD HTML 2.0//EN\">\n"
      }

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
        self << Waves.application.views[:layouts].process( request ) do
          send( name, assigns )
        end
      end

      # The doctype method simply generates a valid DOCTYPE declaration for your page.
      # Valid options are defined in the +DOCTYPES+ constant.
      def doctype(type) ; self << DOCTYPES[type||:html4_strict] ; end

    end
  end
end
