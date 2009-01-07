module Waves

  module Views

    class NoTemplateError < Exception # :nodoc:
    end

    def self.renderers ; @renderers ||= [] ; end

    module Mixin

      attr_reader :request

      include Waves::ResponseMixin

      def self.included( target )
        target.send(:include, Ext) unless target.instance_methods.include?("render")  #Don't redefine render
        def target.process( request, *args, &block )
          self.new( request ).instance_exec( *args, &block )
        end
      end

      def initialize( request )
        @request = request
        @layout = :default
        clear! if respond_to?(:clear!)  #For Hoshi compatibility
      end
      
      def renderer_extensions
        Views.renderers.map { |r| r::Extension }
      end
      
      def template_path(name)
        "templates/#{self.class.basename.snake_case}/#{name}"
      end

      def template_file(name)
        # globbing on a {x,y,z} group returns the found files in x,y,z order
        template = Dir["#{template_path(name)}.{#{renderer_extensions.join(',')}}"].first
        raise NoTemplateError.new( path ) unless template
        template
      end

      # The View mixin extension includes functionality that may be incompatible
      # with some template engines.  It is included when the Mixin is included
      # unless the target class is incompatible
      module Ext
        # Render the template found in the directory named after this view (snake cased, of course)
        # E.g. App::Views::Gnome.new.render( "stink" ) would look for templates/gnome/stink.<ext>
        
        def render( name, assigns={})
          file = template_file(name)
          ext = File.extname(file).slice(1..-1)
          self.send( ext, File.read(file), assigns.merge!( :request => request ))
        end

        # Render the template with the name of the missing method.
        def method_missing(name,*args) ; render( name, *args ) ; end
      end
      
    end

    class Base ; include Mixin ; end

  end
  

end
