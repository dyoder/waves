module Waves

  # Waves::Mapping is a mixin for defining Waves URI mappings (mapping a request to Ruby code).
  # Mappings can work against the request url, path, and elements of the request (such as the
  # request method or accept header). Mappings may also include before, after, or wrap filters
  # to be run if they match the request. Mappings are created using an appropriate mapping method
  # along with a URL pattern (a string or regular expression), a hash of constraint options, and
  # a block, which is the code to run if the pattern matches.
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
		  if path.is_a? Hash
		    options = path
	    else
	      options[:path] = path
      end
			filters[:before] << [ options, block ]
		end
		
		# Similar to before, except it runs its actions after any matching +url+ or +path+ actions.
		def after( path, options = {}, &block )
		  if path.is_a? Hash
		    options = path
	    else
	      options[:path] = path
      end
			filters[:after] << [ options, block ]
		end
		
		# Run the action before and after the matching +url+ or +path+ action.
		def wrap( path, options = {}, &block )
		  if path.is_a? Hash
		    options = path
	    else
	      options[:path] = path
      end
			filters[:before] << [ options, block ]
			filters[:after] << [ options, block ]
		end		

    # Maps a request to a block. Don't use this method directly unless you know what 
    # you're doing. Use +path+ or +url+ instead.
		def map( path, options = {}, &block )
		  if path.is_a? Hash
		    options = path
	    else
	      options[:path] = path
      end
			mapping << [ options, block ]
		end
		
		# Match pattern against the +request.path+, along with satisfying any constraints 
		# specified by the options hash. If the pattern matches and the constraints are satisfied,
		# run the block. Only one +path+ or +url+ match will be run (the first one).
		def path( pat, options = {}, &block )
			options[:path] = pat; map( options, &block )
		end

		# Match pattern against the +request.url+, along with satisfying any constraints 
		# specified by the options hash. If the pattern matches and the constraints are satisfied,
		# run the block. Only one +path+ or +url+ match will be run (the first one).
		def url( pat, options = {}, &block )
			options[:url] = pat; map( options, &block )
		end
		
		# Maps the root of the application to a block. If an options hash is specified it must
		# satisfy those constraints in order to run the block.
		def root( options = {}, &block )
      path( %r{^/?$}, options, &block )
	  end
		
		# Match the given request against the defined rules. This is typically only called
		# by a dispatcher object, so you shouldn't typically use it directly.
		def []( request )
		  
			rx = { :before => [], :after => [], :action => nil }
			
			( filters[:before] + filters[:wrap] ).each do | options, function |
			  matches = match( request, options, function )
			  rx[:before] << matches if matches
			end
			
			mapping.find do | options, function |
			  rx[:action] = match( request, options, function )
				break if rx[:action]
			end
			
			( filters[:after] + filters[:wrap] ).each do | options, function |
			  matches = match( request, options, function )
			  rx[:after] << matches if matches
			end
			
			not_found(request) unless rx[:action]
			
			return rx
		end
		
		# Clear all mapping rules
		def clear
		  @mapping = @filters = nil;
	  end		
				
		private
		
		def mapping; @mapping ||= []; end
		
		def filters; @filters ||= { :before => [], :after => [], :wrap => [] }; end

		def not_found(request)
			raise Waves::Dispatchers::NotFoundError.new( request.url + ' not found.')
		end
		
		def match ( request, options, function )
		  return nil unless satisfy( request, options )
		  if options[:path]
		    matches = options[:path].match( request.path )
	    elsif options[:url]
	      matches = options[:url].match( request.url )
      end
      return [ function, matches ? matches[1..-1] : nil ]
	  end
	  
		def satisfy( request, options )
      options.nil? or options.all? do |name,wanted|
        got = request.send( name ) rescue request.env[  ( name =~ /^rack\./ ) ? 
          name.to_s.downcase : name.to_s.upcase ]
        ( ( wanted.is_a?(Regexp) && wanted.match( got.to_s ) ) or 
          got.to_s == wanted.to_s ) unless ( wanted.nil? or got.nil? )
      end
    end
	end

end
