module Waves
  
  # Helper methods can be defined for any view template by simply defining them within the default Helper module in <tt>helpers/default.rb</tt> of the generated application. Helpers specific to a particular View class can be explicitly defined by creating a helper module that corresponds to the View class. For examples, for the +User+ View class, you would define a helper module in <tt>user.rb</tt> named +User+.
  #
  # The default helper class initially includes a wide-variety of helpers, including helpers for layouts, Textile formatting, rendering forms, and nested views, as well as helpers for accessing the request and response objects. More helpers will be added in future releases, but in many cases, there is no need to include all of them in your application.
  module Helpers

    # Common helpers are helpers that are needed for just about any Web page. For example,
    # each page will likely have a layout and a doctype.

    module DocType

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

      def doctype(type) ; self << DOCTYPES[type||:html4_strict] ; end
      
    end
  end
end
