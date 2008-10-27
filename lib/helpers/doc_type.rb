module Waves
  
  module Helpers

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
