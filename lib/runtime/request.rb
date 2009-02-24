module Waves
  
  # Waves::Request represents an HTTP request and provides convenient methods for accessing request attributes. 
  # See Rack::Request for documentation of any method not defined here.

  class Request

    class ParseError < Exception ; end

    class Query ; include Attributes ; end

    attr_reader :response, :session, :traits

    # Create a new request. Takes a env parameter representing the request passed in from Rack.
    # You shouldn't need to call this directly.
    def initialize( env )
      @traits = Class.new { include Attributes }.new( :waves => {} )
      @request = Rack::Request.new( env ).freeze
      @response = Waves::Response.new( self )
      @session = Waves::Session.new( self )
    end
    
    def rack_request; @request; end
    
    # Methods delegated directly to rack
    %w( url scheme host port body query_string content_type media_type content_length referer ).each do |m|
      define_method( m ) { @request.send( m ) }
    end

    # The request path (PATH_INFO). Ex: +/entry/2008-01-17+
    def path ; @request.path_info ; end

    # Access to "params" - aka the query string - as a hash
    def query ; @request.params ; end
    
    alias_method :params, :query
    alias_method :domain, :host

    # Request method predicates, defined in terms of #method.
    %w{get post put delete head options trace}.
      each { |m| define_method( m ) { method.to_s == m } }

    # The request method. Because browsers can't send PUT or DELETE
    # requests this can be simulated by sending a POST with a hidden
    # field named '_method' and a value with 'PUT' or 'DELETE'. Also
    # accepted is when a query parameter named '_method' is provided.
    def method
      @method ||= ( ( ( m = @request.request_method.downcase ) == 'post' and 
        ( n = @request['_method'] ) ) ? n.downcase : m ).intern
    end
    
    def []( key ) ; @request.env[ key.to_s.upcase ] ; end
    
    # access HTTP headers as methods
    def method_missing( name, *args, &body )
      if args.empty? and not body
        cache_method_missing name, <<-CODE, *args, &body
          key = "HTTP_#{name.to_s.upcase}"
          @request.env[ key ] if @request.env.has_key?( key )
        CODE
      else
        super
      end
    end
    

    # Raise a not found exception.
    def not_found
      raise Waves::Dispatchers::NotFoundError, "#{@request.url} not found." 
    end

    # Issue a redirect for the given path.
    def redirect( path, status = '302' )
      raise Waves::Dispatchers::Redirect.new( path, status )
    end
        
    class Accept < Array
      
      def =~(arg) ; self.include? arg ; end
      def ===(arg) ; self.include? arg ; end
      
      def include?(arg)
        return arg.any? { |pat| self.include?( pat ) } if arg.is_a? Array
        arg = arg.to_s.split('/')
        self.any? do |entry|
          false if entry == '*/*' or entry == '*'
          entry = entry.split('/')
          if arg.size == 1 # implicit wildcard in arg
            arg[0] == entry[0] or arg[0] == entry[1]
          else
            arg == entry
          end
        end
      end
      
      # TODO parsing must be optimized.
      def self.parse(str)
    	regexp_1 = Regexp.new(/([^,][^;]*[^,]*)/)

    	terms = str.scan(regexp_1)
    	terms = terms.map{ |t| extract_term_and_value(t.to_s) }
    	sorted_terms = terms.sort do |term1, term2|
      		term2[1] <=> term1[1]
    	end
    	sorted_terms.inject(self.new){|value, terms| value << terms[0].split(',').map{|x| x.strip} }.flatten.uniq
  	  end
  
  	  def self.extract_term_and_value(txt)
    	res = txt.split(';')
    	q = (res.select{ |param| param =~ /q=/})[0]
    	q = q ? q.gsub(/[a-zA-Z =]*/, '').to_f : 1.0
    	[res[0], q]
  	  end

      #def self.parse(string)
      #  string.split(',').inject(self.new) { |a, entry| a << entry.split( ';' ).first.strip; a }
      #end
      
      def default
        #return 'text/html' if self.include?('text/html')
        #find { |entry| ! entry.match(/\*/) } || 'text/html'
        return 'text/html' if self.size == 0
        return self.first
      end
      
    end
    
    ## this is a hack - need to incorporate browser variations for "accept" here ...
    ## def accept ; @accept ||= Accept.parse(@request.env['HTTP_ACCEPT']).unshift( Waves.config.mime_types[ path ] ).compact.uniq ; end
    ## def accept ; @accept ||= Accept.parse( Waves.config.mime_types[ path.downcase ] || 'text/html' ) ; end
    
    # parsing accept header based on rfc2616 - A-BNF in section 14.1
    def accept 	
    	@accept ||= Accept.parse(@request.env['HTTP_ACCEPT'])
    	ext = Waves.config.mime_types[ path ]
    	@accept.unshift( ext ) if !ext.nil? and !(@accept=~( ext ))
    	@accept 
    end
    
    # TODO verify the parsing of these accept-headers.
    def accept_charset ; @charset ||= Accept.parse(@request.env['HTTP_ACCEPT_CHARSET']) ; end
    def accept_language ; @lang ||= Accept.parse(@request.env['HTTP_ACCEPT_LANGUAGE']) ; end
    # adding accept_encoding
    def accept_encoding ; @enc ||= Accept.parse(@request.env['HTTP_ACCEPT_ENCODING']) ; end

    module Utilities
      
      def self.destructure( hash )
        destructured = {}
        hash.keys.map { |key| key.split('.') }.each do |keys|
          destructure_with_array_keys(hash, '', keys, destructured)
        end
        destructured
      end

      private

      def self.destructure_with_array_keys( hash, prefix, keys, destructured )
        if keys.length == 1
          key = "#{prefix}#{keys.first}"
          val = hash[key]
          destructured[keys.first.intern] = case val
          when String
            val.strip
          when Hash, Array
            val
          when Array
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
    
  end

end


