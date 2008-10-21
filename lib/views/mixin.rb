module Waves

  module Views

    # A class method that returns the known Renderers, which is any module that is defined within Waves::Renderers and includes the Renderers::Mixin.
    # You can define new Renderers simply be reopening Waves::Renderers and defining a module that mixes in Renderers::Mixin.
    def self.renderers ; @renderers ||= [] ; end
    
    def self.renderer_for(path)
      @renderers.find do |renderer|
        File.extname( path ) == ".#{renderer::Extension}" or File.exists?( renderer.filename( path ) )
      end
    end
    
    def self.render( path, assigns = {} )
      template = Views.renderer_for(path) 
      raise NoTemplateError.new( path ) if template.nil?
      template.render( path, assigns )
    end

    class NoTemplateError < Exception # :nodoc:
    end

    # The View mixin simply sets up the machinery for invoking a template, along with methods for accessing
    # the request assigns and the standard interface for invoking a view method.
    module Mixin

      attr_reader :request

      include Waves::ResponseMixin

      def self.included( target )
        def target.process( request, *args, &block )
          self.new( request ).instance_exec( *args, &block )
        end
      end

      def initialize( request ) ; @request = request ; @layout = :default ; end

      # Return the first renderer for which a template file can be found.
      # Uses Renderers::Mixin.filename to construct the filename for each renderer.
      def renderer(path) ; Views.renderer_for(:templates / path) ; end

      # Render the template found in the directory named after this view (snake cased, of course)
      # E.g. App::Views::Gnome.new.render( "stink" ) would look for templates/gnome/stink.<ext>
      def render( path, assigns = {} )
        qpath = "#{self.class.basename.snake_case}/#{path}"
        Waves.log.debug "Rendering template: #{qpath}"
        Views.render(:templates / qpath, assigns.merge!( :request => request ))
      end

      # Render the template with the name of the missing method.
      def method_missing(name,*args) ; render( name, *args ) ; end

    end

    class Base ; include Mixin ; end

  end
  

end
