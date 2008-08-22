module Waves

  # = Mappings
  #
  # Mappings are the heart of Waves, the system whereby the madding crowd of slovenly requests are
  # sorted, segregated, cleaned and dressed, put on their best behavior, and shunted through as complex 
  # a series of filters as you, the web developer, could wish for.
  # 
  # More simply, mappings are the routes which determine how a request will be handled.  Each mapping registers
  # an action against a set of constraints, and a request must satisfy these constraints for the action to be usable.
  # You can describe a Pattern that the URI path must match, or specify a domain, the URL scheme, 
  # or HTTP headers.  How the mappings are used is determined by the particular Dispatcher in operation.
  # 
  # There are three basic types of mapping:  responses, filters, and exception handlers
  #
  # == Responses
  # 
  # A response mapping provides the primary action in answer to a HTTP request.  That is, the return value of an action
  # is written to the HTTP response body.  The default dispatcher runs only the first response mapping it finds 
  # that matches the request.
  #
  # == Filters
  # 
  # The filter mappings are :before, :after, and :always.  Filters may be used for side effects
  # or to contribute to the response.  The return value of a filter is discarded, so filters must manipulate the 
  # response object directly to effect any changes.  
  #
  # The default dispatcher runs all :before mappings that match the request before searching for a response mapping.
  # After evaluating the response action, the dispatcher runs all :after filters that match the request.  Finally, after
  # processing any exceptions that were thrown by the before, response, and after actions, the dispatcher runs 
  # every :always mapping that matches the request.  Thus the :always filters function like +ensure+ in Ruby.
  #
  # == Exception handlers
  # 
  # Handler mappings take an exception class as a constraint, in addition to any of the other possible constraints.
  # The default dispatcher uses an exception handler, if it can find one, to process exceptions thrown by 
  # the before, response, and after actions.
  # 
  # = Constraints
  #
  # 
  
  module Mapping
    
    include Functor::Method
    
    METHODS = %w( get put post delete ).map( &:intern )
    RULES = %w( before response after always handle ).map( &:intern )
    
    def mappings ; @mappings ||= Hash.new { |h,k| h[k] = [] } ; end

    def clear ; @mappings = Hash.new { |h,k| h[k] = [] } ; end
    
    def method_missing( name, *args, &block )
      return super unless RULES.include? name
      args << block if block_given?
      mappings[ name ] << map( *args )
    end
    
    def on( options, &block )
      args = [options, block].compact
      mappings[ :response ] << map( *args )
    end
    
    
    
    def with( options, &block )
      @options = options; yield if block_given? ; @options = nil
    end

    # primary input like: response( :klump, :get => [ "foo" ] ) { bar }
    functor( :map, Symbol, Hash, Proc ) do | name, options, block |
      options[:as] = name ; options[:block] = block ; map( options )
    end # no longer needed?
    
    # primary input like: on( :get => [ "foo" ], :as => :klump ) { bar }
    functor( :map, Hash, Proc ) do | options, block |
      options[:block] = block; map( options )
    end
    
    # primary input like response( :klump, :get => [ "foo" ] ); missing a block
    functor( :map, Symbol, Hash ) { | name, options | options[:as] = name ; map( options ) } # no longer needed?
    
    # secondary input where &block has already been slurped into the options hash
    functor( :map, Hash ) do | options |
      raise ArgumentError, "A mapping must have a block or an :as param" if !options[:as] && !options[:block]
      options = ( @options || {} ).merge( options )
      options[ :method ] = method = METHODS.find { |method| options[ method ] }
      options[ :path ] = options[ method ] if method
      Action.new( options )
    end

    # section for Exception Handlers
    exception = lambda { | klass | klass.ancestors.include?( Exception ) if klass.is_a?( Class ) }
    
    functor( :map, exception, String, Hash, Proc ) do | e, name, options, block |
      options[ :as ] = name ; map( e, options, block )
    end
    
    functor( :map, exception, Hash, Proc ) do | e, options, block |
      options[ :block ] = block ; map( e, options )
    end
    functor( :map, exception, Proc ) { | e, block | map( e, { :block => block } ) }
    functor( :map, exception, Hash ) { | e, options | Handler.new( e, options ) }
    
    
    def []( request )
      results = Hash.new { |h,k| h[k] = [] }
      RULES.each do | rule |
        mappings[ rule ].each { | action | ( binding = action.bind( request ) ) and results[ rule ].push( binding ) }
      end
      return results
    end  

    private :map
    
  end

end