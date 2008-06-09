module Waves

  #
  # Controllers in Waves are simply classes that provide a request / response
  # context for operating on a model. While models are essentially just a way
  # to manage data in an application, controllers manage data in response to
  # a request. For example, a controller updates a model instance using
  # parameters from the request.
  #
  # Public controller methods simply return data (a resource), if necessary, that
  # can be then used by views to determine how to render that data.
  # Controllers do not determine which view will be invoked. They are
  # independent of the view; one controller method might be suitable for
  # several different views. In some cases, controllers can choose to
  # directly modify the response and possibly even short-circuit the view
  # entirely. A good example of this is a redirect.
  #
  # Controllers, like Views and Mappings, use the Waves::ResponseMixin to
  # provide a rich context for working with the request and response objects.
  # They can even call other controllers or views using the controllers method.
  # In addition, they provide some basic reflection (access to the model and
  # model_name that corresponds to the class name for the given model) and
  # automatic parameter destructuring. This allows controller methods to access
  # the request parameters as a hash, so that a POST variable named
  # <tt>entry.title</tt> is accessed as <tt>params[:entry][:title]</tt>.
  #
  # Controllers often do not have to be explicitly defined. Instead, one or more
  # default controllers can be defined that are used as exemplars for a given
  # model. By default, the +waves+ command generates a single default, placed in
  # the application's <tt>controllers/default.rb</tt> file. This can be modified
  # to change the default behavior for all controllers. Alternatively, the
  # <tt>rake generate:controller</tt> command can be used to explicitly define a
  # controller.
  #
  # As an example, the code for the default controller is below for the Blog application.
  #
  #   module Blog
  #     module Controllers
  #       class Default
  #
  #         # Pick up the default controller methods, like param, url, etc.
  #         include Waves::Controllers::Mixin
  #
  #         # This gets me the parameters associated with this model
  #         def attributes; params[model_name.singular.intern]; end
  #
  #         # A simple generic delegator to the model
  #         def all; model.all; end
  #
  #         # Find a specific instance based on a name or raise a 404
  #         def find( name ); model[ :name => name ] or not_found; end
  #
  #         # Create a new instance based on the request params
  #         def create; model.create( attributes ); end
  #
  #         # Update an existing record. find will raise a 404 if not found.
  #         def update( name )
  #           instance = find( name )
  #           instance.set( attributes )
  #           instance.save_changes
  #         end
  #
  #         # Find and delete - or will raise a 404 if it doesn't exist
  #         def delete( name ); find( name ).destroy; end
  #
  #       end
  #     end
  #   end
  #
  # Since the mapping file handles "glueing" controllers to views, controllers
  # don't have to be at all concerned with views. They don't have to set
  # instance variables, layouts, or contain logic to select the appropriate
  # view based on the request. All they do is worry about updating the model
  # when necessary based on the request.

  module Controllers

    #
    # Waves::Controllers::Mixin adapts a controller class for use in mappings and provides utility methods.     
    # It is included in controllers autocreated by the Default foundation, so you do not need to include
    # it in subclasses of the same. 
    #
    # The utility methods include simple reflection to allow controller methods
    # to be written generically (i.e., without reference to a specific model) and
    # parameter destructuring for the request parameters.
    #

    module Mixin

      attr_reader :request

      include Waves::ResponseMixin

      # When this mixin is included it adds a class method named +process+,
      # which accepts a request object and a block. The +process+ method initializes the
      # controller with the request, then evaluates the block using +instance_eval+. This allows the
      # controller to be used from within a mapping lambda (i.e. a ResponseProxy).

      def self.included( mod )
        def mod.process( request, &block )
          self.new( request ).instance_eval( &block )
        end
      end

      def initialize( request )
        @request = request
      end

      # The params variable is taken from the request object and "destructured", so that
      # a parameter named 'blog.title' becomes:
      #
      #   params['blog']['title']
      #
      # If you want to access the original parameters object, you can still do so using
      # +request.params+ instead of simply +params+.
      def params; @params ||= destructure(request.params); end

      # Returns the name of the model corresponding to this controller by taking the basename
      # of the module and converting it to snake case. If the model plurality is different than
      # the controller, this will not, in fact, be the model name.
      def model_name; self.class.basename.snake_case; end

      # Returns the model corresponding to this controller by naively assuming that 
      # +model_name+ must be correct. This allows you to write generic controller methods such as:
      #
      #   model.find( name )
      #
      # to find an instance of a given model. Again, the plurality of the controller and
      # model must be the same for this to work.
      def model; Waves.application.models[ model_name.intern ]; end
      
      def attributes; params[model_name.singular.intern]; end
      
      private

      def destructure( hash )
        destructured = {}
        hash.keys.map { |key| key.split('.') }.each do |keys|
          destructure_with_array_keys(hash, '', keys, destructured)
        end
        destructured
      end

      def destructure_with_array_keys( hash, prefix, keys, destructured )
        if keys.length == 1
          key = "#{prefix}#{keys.first}"
          val = hash[key]
          destructured[keys.first.intern] = case val
          when String
            val.strip
          when Hash
            val
          when nil
            raise key.inspect
          end
        else
          destructured = ( destructured[keys.first.intern] ||= {} )
          new_prefix = "#{prefix}#{keys.shift}."
          destructure_with_array_keys( hash, new_prefix, keys, destructured )
        end
      end

    end

    # :)
    const_set( :Base, Class.new ).module_eval { include Mixin }  

  end

end
