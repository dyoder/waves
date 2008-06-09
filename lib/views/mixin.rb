module Waves

  # Views in Waves are ultimately responsible for generating the response body. Views mirror controllers - both have full access to the request and response, and both may modify the response and even short-circuit the request processing and return a result by calling redirect or calling Response#finish.
  #
  # Views, like controllers, are classes with methods that are invoked by a mapping block (see Waves::Mapping). View instance methods take an assigns hash that are typically converted into instance variables accesible from within a template.
  #
  # Like controllers, a default implementation is provided by the +waves+ command when you first create your application. This default can be overridden to change the behaviors for all views, or you can explicitly define a View class to provide specific behavior for one view.
  #
  # The default implementation simply determines which template to render and renders it, returning the result as a string. This machinery is provided by the View mixin, so it is easy to create your own View implementations.
  #
  # = Templates
  #
  # Although you won't typically need to modify or define View classes, you will often create and modify templates. Templates can be evaluated using any registered Renderer. Two are presently packaged with Waves: Markaby and Erubis. Templates have access to the assigns hash passed to the view method as instance variables. These can be explicitly defined by the mapping file or whomever is invoking the view.
  #
  # *Example*
  #
  #   # Find the story named 'home' and pass it as @story into the "story/show" template
  #   use( :story ) | controller { find( 'home' ) } | view { |x| show( :story => x ) }
  #
  # = Helpers
  #
  # Helper methods can be defined for any view template by simply defining them within the default Helper module in <tt>helpers/default.rb</tt> of the generated application. Helpers specific to a particular View class can be explicitly defined by creating a helper module that corresponds to the View class. For examples, for the +User+ View class, you would define a helper module in <tt>user.rb</tt> named +User+.
  #
  # The default helper class initially includes a wide-variety of helpers, including helpers for layouts, Textile formatting, rendering forms, and nested views, as well as helpers for accessing the request and response objects. More helpers will be added in future releases, but in many cases, there is no need to include all of them in your application.
  #
  # = Layouts
  #
  # Layouts are defined using the +Layout+ view class, and layout templates are placed in the +layout+ directory of the +templates+ directory. Layouts are explicitly set within a template using the +layout+ method.
  #
  # *Example*
  #
  #   layout :default, :title => @story.title do
  #     h1 @story.title
  #     textile @story.content
  #   end
  #
  #
  # The layout method takes a name and an assigns hash that will be available within the layout template as instance variables. In this example, <tt>@title</tt> will be defined as <tt>@story.title</tt> within the layout template named 'default.'
  #
  # Any number of layouts may be included within a single view, and layouts may even be nested within layouts. This makes it possible to create large numbers of highly structured views that can be easily changed with minimal effort. For example, you might specify a layout associated with form elements. By incorporating this into your views as a +layout+ template, you can make changes across all your forms by changing this single template.
  #
  # = Nested Views
  #
  # It is easy to include one view inside another. A common use for this is to define one set of templates for reusable content 'fragments' (somewhat akin to partials in Rails) and another set that incorporate these fragments into specific layouts. Including a view from within another view is done, logically enough, using the +view+ method.
  #
  # *Example*
  #
  #   # include the summary view for Story
  #   view :story, :summary, :story => @story
  #
  # = Request And Response Objects
  #
  # As always, the request and response objects, and a wide-variety of short-cut methods, are available within view templates via the Waves::ResponseMixin.
  #

  module Views

    class NoTemplateError < Exception ; end

    # A class method that returns the known Renderers, which is any module that is defined within Waves::Renderers and includes the Renderers::Mixin. You can define new Renderers simply be reopening Waves::Renderers and defining a module that mixes in Renderers::Mixin.
    def Views.renderers
      return [] if Renderers.constants.nil?
      Renderers.constants.sort.inject([]) do |rx,cname|
        ( Module === (c=Renderers.const_get(cname)) &&
          c < Renderers::Mixin ) ? ( rx << c ) : rx
      end
    end

    # The View mixin simply sets up the machinery for invoking a template, along with methods for accessing the request context and the standard interface for invoking a view method.
    module Mixin

      attr_reader :request

      include Waves::ResponseMixin

      def self.included( c )
        def c.process( request, *args, &block )
          self.new( request ).instance_exec( *args, &block )
        end
      end

      def initialize( request )
        @request = request
        @layout = :default
      end

      # Return the first renderer for which a template file can be found.
      # Uses Renderers::Mixin.filename to construct the filename for each renderer.
      def renderer(path)
        Views.renderers.find do |renderer|
          File.exists?( renderer.filename( path ) )
        end
      end

      def render( path, context = {} )
        context.merge!( :request => request )
        template = renderer( path ) || renderer( :generic / File.basename(path) )
        raise NoTemplateError.new( path ) if template.nil?
        template.render( path, context )
      end

      def method_missing(name,*args)
        render( "/#{self.class.basename.snake_case}/#{name}", *args )
      end

    end

    # :)
    const_set( :Base, Class.new ).module_eval { include Mixin }  

  end
  

end
