module Waves

  module Mapping
    
    include Functor::Method
    
    METHODS = %w( get put post delete ).map( &:intern )
    RULES = %w( before action after always, handle ).map( &:intern )
    
    def mappings
      @mappings ||= Hash.new { |h,k| h[k] = [] }
    end
    
    def method_missing( name, *args, &block )
      return super unless RULES.include? name
      map( name, args, &block )
    end
    
    def with( options, &block )
      @options = options; yield if block_given? ; @options = nil
    end

    functor( :map, String, Array, Proc ) { | rule, args, block | map( *( args << block ) ) }
    functor( :map, String, Array ) { | rule, args | mappings[ rule ] << map( *args ) }
    functor( :map, String, Hash, Proc ) do | name, options, block |
      options[:name] = name ; options[:block] = block ; map( options )
    end
    functor( :map, String, Hash ) { | name, options | options[:name] = name ; map( options ) }
    functor( :map, Hash ) do | options |
      options = ( @options || {} ).merge( options )
      options[ :method ] = method = METHODS.find { |method| options[ method ] }
      options[ :pattern ] = options[ method ]
      Action.new( options )
    end
    functor( :map, Exception, String, Hash, Proc ) do | e, name, options, block |
      options[:name] = name ; map( e, options, block )
    end
    functor( :map, Exception, Hash, Proc ) do | e, options, block |
      options[:block] = block ; map( e, options )
    end
    functor( :map, Exception, Hash ) { | options, block | Handler.new( e, options ) }
        
    def []( request )
      returning Hash.new { |h,k| h[k] = [] } do | results |
        RULES.each do | rule |
          mappings[ rule ].each { | action | binding = action.bind( request ) and results[ rule ].push( binding ) }
        end
      end
    end  

    private
    
    def normalize( options )
    end
    
  end

end