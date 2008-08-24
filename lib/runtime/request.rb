module Waves
  
  # Waves::Request represents an HTTP request and provides convenient methods for accessing request attributes. 
  # See Rack::Request for documentation of any method not defined here.

  class Request

    class ParseError < Exception ; end

    class Query ; include Attributes ; end

    attr_reader :response, :session, :blackboard

    # Create a new request. Takes a env parameter representing the request passed in from Rack.
    # You shouldn't need to call this directly.
    def initialize( env )
      @request = Rack::Request.new( env )
      @response = Waves::Response.new( self )
      @session = Waves::Session.new( self )
      @blackboard = Waves::Blackboard.new( self )
    end
    
    def rack_request; @request; end

    # Accessor not explicitly defined by Waves::Request are delegated to Rack::Request.
    # Check the Rack documentation for more information.
    def method_missing( name, *args )
      ( ( @request.respond_to?( name ) and @request.send( name,*args ) ) or
        ( args.empty? and ( @request.env[ "HTTP_#{name.to_s.upcase}" ] or 
          @request.env[ "rack.#{name.to_s.downcase}" ] ) ) or super )
    end

    # The request path (PATH_INFO). Ex: +/entry/2008-01-17+
    def path ; @request.path_info ; end

    # The request domain. Ex: +www.fubar.com+
    def domain ; @request.host ; end

    # The request content type.
    def content_type ; @request.env['CONTENT_TYPE'] ; end
    

    # Request method predicates, defined in terms of #method.
    METHODS = %w{get post put delete head options trace}
    METHODS.each { |m| define_method( m ) { method == m } }

    # The request method. Because browsers can't send PUT or DELETE
    # requests this can be simulated by sending a POST with a hidden
    # field named '_method' and a value with 'PUT' or 'DELETE'. Also
    # accepted is when a query parameter named '_method' is provided.
    def method
      @method ||= ( ( ( m = @request.request_method.downcase ) == 'post' and 
        ( n = @request['_method'] ) ) ? n.downcase : m ).intern
    end

    # Raise a not found exception.
    def not_found
      raise Waves::Dispatchers::NotFoundError.new( @request.url + ' not found.' )
    end

    # Issue a redirect for the given path.
    def redirect( path, status = '302' )
      raise Waves::Dispatchers::Redirect.new( path, status )
    end
    
    class Accept < Array
      
      def =~(arg) ; self.include? arg ; end
      def ===(arg) ; self.include? arg ; end
      
      # try the normal include?, then if the arg is a Regexp, see if anything matches
      def include?(arg)
        super || self.any? do |entry|
          return true if  entry == '*/*' || entry == '*' || arg === entry
          if entry.match('\*') && arg.respond_to?(:split)
            a, e = arg.split('/'), entry.split('/')
            return true if e[0] == '*' && a[1] == e[1]
            return true if e[1] == '*' && a[0] == e[0]
          else
            false
          end
        end
      end
      
      def self.parse(string)
        string.split(',').inject(self.new) { |a, entry| a << entry.split( ';' ).first.strip; a }
      end
      
    end
    
    def accept ; Accept.parse(@request.env['HTTP_ACCEPT']) ; end
    def accept_charset ; Accept.parse(@request.env['HTTP_ACCEPT_CHARSET']) ; end
    def accept_language ; Accept.parse(@request.env['HTTP_ACCEPT_LANGUAGE']) ; end

  end

end


