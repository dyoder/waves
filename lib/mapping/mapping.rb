module Waves

  module Mapping
    
    METHODS = %w( get put post delete ).map( &:intern )
    RULES = %w( before action after always ).map( &:intern )
    
    def mappings
      @mappings ||= Hash.new { |h,k| h[k] = [] }
    end
    
    def before( options, &block )
    end
    
    def wrap( name, *args, &block )
      before( name, *args, &block ) ; after( name, *args, &block )
    end

    def after( options, &block )
    end
    
    def always( options, &block )
    end
    
    def handle( exception )
    end

    
    def with( options, &block )
      @options = options; yield if block_given? ; @options = nil
    end

    def path( name, options = {}, &block )
      map( options.merge!( :name => name, :target => :path ), &block )
    end
    
    def url( name, options = {}, &block )
      map( options.merge!( :name => name, :target => :url ), &block )
    end
    
    def map( options, &block )
      options = ( @options || {} ).merge( options )
      options[ :target ] ||= :path
      options[ :method ] = method = METHODS.find { |method| options[ method ] }
      options[ :pattern ] = options[ method ]
      mappings[ :action ].push( Action.new( options, &block ) )
    end
    
    def []( request )
      returning Hash.new { |h,k| h[k] = [] } do | results |
        RULES.each do | rule |
          mappings[ rule ].each { | action | binding = action.bind( request ) and results[ rule ].push( binding ) }
        end
      end
    end  
          
  end

end