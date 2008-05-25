module Waves

  # Mappings in Waves are the interface between the request dispatcher and your
  # application code.  The dispatcher matches each request against the mappings
  # to determine a primary action and to collect sets of before, after, wrap, 
  # and always actions.  The dispatcher also looks for an exception handler 
  # registered in the mappings when attempting a rescue.
  # 
  # Each mapping associates a block with a set of constraints.  Mappings can be
  # one of several types:
  # 
  # - action (the actual request processing and response)
  # - handle (exception handling)
  # - before 
  # - after
  # - wrap (registers its block as both a before and after action)
  # - always (like an "ensure" clause in a rescue)
  # 
  # Actions are registered using path, url, or map.  The other types may be 
  # registered using methods named after the type.
  # 
  # 
  # The available constraints are:
  # 
  # - a string or regexp that the path or url must match
  # - parameters to match against the HTTP request headers and the Rack-specific variables (e.g. 'rack.url_scheme')
  # - an additional hash reserved for settings not related to the Rack request (e.g. giving Rack handers special instructions for certain requests.  See threaded? )
  # 
  # The dispatcher evaluates mapping blocks in an instance of ResponseProxy, 
  # which provides access to foundational classes of a Waves application (i.e. controllers and views)
  #
  # == Examples
  #
  #   resource = '([\w\-]+)'
  #   name = '([\w\-\_\.\+\@]+)'
  #
  #   path %r{^/#{resource}/#{name}/?$} do |resource, name|
  #     "Hello from a #{resource} named #{name.capitalize}."
  #   end
  #
  # In this example, we are using binding regular expressions defined by +resource+
  # and +name+. The matches are passed into the block as parameters. Thus, this
  # rule, given the URL '/person/john' will return:
  #
  #   Hello from a person named John.
  #
  # The given block may simple return a string. The content type is inferred from the request
  # if possible, otherwise it defaults to +text+/+html+.
  #
  #   path '/critters', :method => :post do
  #     request.content_type
  #   end
  #
  #   /critters # => 'text/html'
  #
  # In this example, we match against a string and check to make sure that the request is a
  # POST. If so, we return the request content_type. The request (and response) objects are
  # available from within the block implicitly.
  #
  # = Invoking Controllers and Views
  #
  # You may invoke a controller or view method for the primary application by using the
  # corresponding methods, preceded by the +use+ directive.
  #
  # == Examples
  #
  #   path %r{^/#{resource}/#{name}/?$} do |resource, name|
  #     resource( resource ) do
  #       controller { find( name ) } |  view { | instance | show( resource => instance ) }
  #     end
  #   end
  #
  # In this example, we take the same rule from above but invoke a controller and view method.
  # We use the +resource+ directive and the resource parameter to set the MVC instances we're going
  # to use. This is necessary to use the +controller+ or +view+ methods. Each of these take
  # a block as arguments which are evaluated in the context of the instance. The +view+ method
  # can further take an argument which is "piped" from the result of the controller block. This
  # isn't required, but helps to clarify the request processing. Within a view block, a hash
  # may also be passed in to the view method, which is converted into instance variables for the
  # view instance. In this example, the +show+ method is assigned to an instance variable with the
  # same name as the resource type.
  #
  # So given the same URL as above - /person/john - what will happen is the +find+ method for
  # the +Person+ controller will be invoked and the result passed to the +Person+ view's +show+
  # method, with +@person+ holding the value returned.
  #
  # Crucially, the controller does not need to know what variables the view depends on. This is
  # the job of the mapping block, to act as the "glue" between the controller and view. The
  # controller and view can thus be completely decoupled and become easier to reuse separately.
  #
  #   url 'http://admin.foobar.com:/' do
  #     resource( :admin ) { view { console } }
  #   end
  #
  # In this example, we are using the +url+ method to map a subdomain of +foobar.com+ to the
  # console method of the Admin view. In this case, we did not need a controller method, so
  # we simply didn't call one.
  #
  # = Mapping Modules
  #
  # You may encapsulate sets of related rules into modules and simply include them into your
  # mapping module. Some rule sets come packaged with Waves, such as PrettyUrls (rules for
  # matching resources using names instead of ids). The simplest way to define such modules for
  # reuse is by defining the +included+ class method for the rules module, and then define
  # the rules using +module_eval+. See the PrettyUrls module for an example of how to do this.
  #
  # *Important:* Using pre-packaged mapping rules does not prevent you from adding to or
  # overriding these rules. However, order does matter, so you should put your own rules
  # ahead of those your may be importing. Also, place rules with constraints (for example,
  # rules that require a POST) ahead of those with no constraints, otherwise the constrainted
  # rules may never be called.

  module Mapping

    # If the pattern matches and constraints given by the options hash are satisfied, run the
    # block before running any +path+ or +url+ actions. You can have as many +before+ matches
    # as you want - they will all run, unless one of them calls redirect, generates an
    # unhandled exception, etc.
    def before( path, options = {}, &block )
      mappings[:before] << [ merge( path, options ), block ]
    end

    # Similar to before, except it runs its actions after any matching +url+ or +path+ actions.
    # Note that after methods will run even if an exception is thrown during processing.
    def after( path, options = {}, &block )
      mappings[:after] << [ merge( path, options ), block ]
    end

    # Run the action before and after the matching +url+ or +path+ action.
    def wrap( path, options = {}, &block )
      mappings[:before] << [ options = merge( path, options ), block ]
      mappings[:after] << [ options, block ]
    end

    # Like after, but will run even when an exception is thrown. Exceptions in
    # always mappings are simply logged and ignored.
    def always( path, options = {}, &block )
      mappings[:always] << [ merge( path, options ), block ]
    end

    # Maps a request to a block. Don't use this method directly unless you know what
    # you're doing. Use +path+ or +url+ instead.
    def map( path, options = {}, &block )
      mappings[:action] << [ merge( path, options ), block ]
    end

    # Match pattern against the +request.path+, along with satisfying any constraints
    # specified by the options hash. If the pattern matches and the constraints are satisfied,
    # run the block. Only one +path+ or +url+ match will be run (the first one).
    def path( path, options = {}, &block )
      map( path, options, &block )
    end

    # Match pattern against the +request.url+, along with satisfying any constraints
    # specified by the options hash. If the pattern matches and the constraints are satisfied,
    # run the block. Only one +path+ or +url+ match will be run (the first one).
    def url( url, options = {}, &block )
      map( options.merge!( :url => url ), &block )
    end

    # Maps the root of the application to a block. If an options hash is specified it must
    # satisfy those constraints in order to run the block.
    def root( options = {}, &block )
      path( '/', options, &block )
    end
    
    # Maps an exception handler to a block.
    def handle( exception, options = {}, &block )
      mappings[:handler] << [ exception, options, block ]
    end

    # Maps a request to a block that will be executed within it's
    # own thread. This is especially useful when you're running
    # with an event driven server like thin or ebb, and this block
    # is going to take a relatively long time.
    def threaded( path, options = {}, &block)
      map( path, options.merge!( :threaded => true ), &block)
    end

    # Determines whether the request should be handled in a separate thread. This is  used
    # by event driven servers like thin and ebb, and is most useful for those methods that
    # take a long time to complete, like for example upload processes. E.g.:
    #
    #   threaded("/upload", :method => :post) do
    #     handle_upload
    #   end
    #
    # You typically wouldn't use this method directly.
    def threaded?( request )
      mapping.find do | options, function |
        match = match( request, options, function )
        options[:threaded] == true if match
      end
    end
    
    # Match the given request against the defined rules. This is typically only called
    # by a dispatcher object, so you shouldn't typically use it directly.
    def []( request )
      returning( Hash.new { |h,k| h[k] = [] } ) do | r |
        r[:before] = ( mappings[:before] + mappings[:wrap] ).map { | opts, blk | match( request, opts, blk ) }.compact
        r[:after] = ( mappings[:after] + mappings[:wrap] ).map { | opts, blk | match( request, opts, blk ) }.compact
        r[:always] = mappings[:always].map { | opts, blk | match( request, opts, blk ) }.compact
        r[:handler] = mappings[:handler].map { | e, opts, blk | match( request, opts, blk ) }.compact.reverse
        mappings[:action].find { | opts, blk | r[:action] = match( request, opts, blk ) }
      end    
    end

    # Clear all mapping rules
    def clear
      @mapping = Hash.new{ |h,k| h[k] = [] }
    end

    private
    
    def mappings ; @mappings ||= Hash.new { |h,k| h[k] = [] } ; end
    def named ; @named ||= Attributes.new ; end
    
    def merge( path, options = {} )
      process( Hash === path ? path : options.merge!( :path => path ) )
    end
    
    def process( options )
      path, key = if options[:path]
        [ options[:path], :path ] 
      elsif options[:url]
        [ options[:url], :url ]
      else
        raise RuntimeError.new("no path or url specified for mapping")
      end
      g = generator( path )
      named[ options[:named] ] = g if options[:named]
      options[ key ] = Regexp.new( "^" + g.call( options, %r{([\w\-\_]+)} ) + "\/?$" )
      return options
    end
    
    def generator( path )
      lambda do |keys,default|
          path.gsub( /\{([\w\-\_]+)\}/ ) { |key| puts "\n\nKEY: #{key[0]}\n\n"; keys[ key[0] ] || default.to_s }
      end
    end

    def match ( request, options, function )
      return nil unless satisfy( request, options )
      return [ function, nil ] if ( options[:path] == true or options[:url] == true )
      matches = options[:path].match( request.path ) if options[:path]
      matches = options[:url].match( request.url ) if options[:url]
      return [ function, matches ? matches[1..-1] : nil ]
    end

    def satisfy( request, options )
      options.nil? or options.all? do |name,wanted|
        return true if wanted == true
        got = request.send( name ) rescue request.env[  ( name =~ /^rack\./ ) ? name.to_s.downcase : name.to_s.upcase ]
        ( ( wanted.is_a?(Regexp) and wanted.match( got.to_s ) ) or got.to_s == wanted.to_s ) unless ( wanted.nil? or got.nil? )
      end
    end
  end
  

end
