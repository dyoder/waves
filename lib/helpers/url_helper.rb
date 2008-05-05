module Waves
  module Helpers
    module UrlHelper

      # Returns the URL for the set of +options+ provided. This takes the 
      # same options as url_for in action controller. For a list, see the 
      # documentation for ActionController::Base#url_for. Note that it'll 
      # set :only_path => true so you'll get the relative /controller/action 
      # instead of the fully qualified http://example.com/controller/action.
      #  
      # When called from a view, url_for returns an HTML escaped url. If you 
      # need an unescaped url, pass :escape => false in the +options+.
      def url_for(options = {}, *parameters_for_method_reference)
        if options.kind_of? Hash
          options = { :only_path => true }.update(options.symbolize_keys)
          escape = options.key?(:escape) ? options.delete(:escape) : true
        else
          escape = true
        end

        url = options[:url] #@controller.send(:url_for, options, *parameters_for_method_reference)
        escape ? html_escape(url) : url
      end


      # Creates a link tag of the given +name+ using a URL created by the set 
      # of +options+. See the valid options in the documentation for 
      # ActionController::Base#url_for. It's also possible to pass a string instead 
      # of an options hash to get a link tag that uses the value of the string as the 
      # href for the link. If nil is passed as a name, the link itself will become 
      # the name.
      #
      # The +html_options+ will accept a hash of html attributes for the link tag.
      # It also accepts 3 modifiers that specialize the link behavior. 
      #
      # * <tt>:confirm => 'question?'</tt>: This will add a JavaScript confirm 
      #   prompt with the question specified. If the user accepts, the link is 
      #   processed normally, otherwise no action is taken.
      # * <tt>:popup => true || array of window options</tt>: This will force the 
      #   link to open in a popup window. By passing true, a default browser window 
      #   will be opened with the URL. You can also specify an array of options 
      #   that are passed-thru to JavaScripts window.open method.
      # * <tt>:method => symbol of HTTP verb</tt>: This modifier will dynamically
      #   create an HTML form and immediately submit the form for processing using 
      #   the HTTP verb specified. Useful for having links perform a POST operation
      #   in dangerous actions like deleting a record (which search bots can follow
      #   while spidering your site). Supported verbs are :post, :delete and :put.
      #   Note that if the user has JavaScript disabled, the request will fall back 
      #   to using GET. If you are relying on the POST behavior, your should check
      #   for it in your controllers action by using the request objects methods
      #   for post?, delete? or put?.
      #
      # You can mix and match the +html_options+ with the exception of
      # :popup and :method which will raise an ActionView::ActionViewError
      # exception.
      #
      #   link_to "Visit Other Site", "http://www.rubyonrails.org/", :confirm => "Are you sure?"
      #   link_to "Help", { :action => "help" }, :popup => true
      #   link_to "View Image", { :action => "view" }, :popup => ['new_window_name', 'height=300,width=600']
      #   link_to "Delete Image", { :action => "delete", :id => @image.id }, :confirm => "Are you sure?", :method => :delete
      def link_to(name, options = {}, html_options = nil, *parameters_for_method_reference)
        if html_options
          html_options = html_options.stringify_keys
          # convert_options_to_javascript!(html_options)
          tag_options = tag_options(html_options)
        else
          tag_options = nil
        end

        url = options.is_a?(String) ? options : self.url_for(options, *parameters_for_method_reference)
        "<a href=\"#{url}\"#{tag_options}>#{name || url}</a>"
      end

      
    end
  end
end