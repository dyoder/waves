module Waves

  module Mapping
    
    include Functor::Method
    
    METHODS = %w( get put post delete ).map( &:intern )
    RULES = %w( before action after always handle ).map( &:intern )
    
    def mappings ; @mappings ||= Hash.new { |h,k| h[k] = [] } ; end
    
    def method_missing( name, *args, &block )
      return super unless RULES.include? name
      args << block if block_given?
      mappings[ name ] << map( *args )
    end
    
    def with( options, &block )
      @options = options; yield if block_given? ; @options = nil
    end

    functor( :map, Symbol, Hash, Proc ) do | name, options, block |
      options[:name] = name ; options[:block] = block ; map( options )
    end
    functor( :map, Symbol, Hash ) { | name, options | options[:name] = name ; map( options ) }
    functor( :map, Hash ) do | options |
      options = ( @options || {} ).merge( options )
      options[ :method ] = method = METHODS.find { |method| options[ method ] }
      options[ :path ] = options[ method ]
      Action.new( options )
    end

    exception = lambda { | klass | klass.ancestors.include?( Exception ) if klass.is_a?( Class ) }
    
    functor( :map, exception, String, Hash, Proc ) do | e, name, options, block |
      options[ :name ] = name ; map( e, options, block )
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