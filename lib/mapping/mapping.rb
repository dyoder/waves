module Waves

  module Mapping
    
    METHODS = %w( get put post delete ).map( &:intern )
    RULES = %w( before action after always ).map( &:intern )
    
    def method_missing( name, *args, &block )
      mappings[ name ].push( map( *args, &block ) )
    end
    
    def wrap( name, *args, &block )
      before( name, *args, &block ) ; after( name, *args, &block )
    end
    
    def with( options, &block )
      @options = options; yield if block_given? ; @options = nil
    end

    def path( name, options = {}, &block )
      mappings[ :action ] = map( options.merge!( :name => name, :target => :path ), &block )
    end
    
    def url( name, options = {}, &block )
      mappings[ :action ] = map( options.merge!( :name => name, :target => :url ), &block )
    end
    
    def map( *args, &block )
      options = ( @options || {} ).merge( normalize( *args ) )
      options[ :target ] ||= :path
      options[ :method ] = method = METHODS.find { |method| options[ method ] }
      options[ :pattern ] = options[ method ]
      Action.new( options, &block )
    end
    
    def []( request )
      results = {} ; RULES.each do | rule |
        results[ rule ] = mappings[ rule ].select do | action | 
          ( params = action.call?( request ) ) and Action::Binding.new( action, params )
        end
      end
      return results
    end  
    
    private
    
    def mappings; @mappings ||= {}; end
    
    include Functor::Method
    
    functor( :normalize, Symbol, Hash ) { | name, options | options.merge!( :name => name ) }
    functor( :normalize, String, Hash ) { | pattern, options | options.merge!( :pattern => pattern ) }
    functor( :normalize, Regexp, Hash ) { | regexp, options | options.merge!( :pattern => regexp ) }
    functor( :normalize, Exception ) { | exception | { :exception => exception } } 
    functor( :normalize, Hash ) { | options | options }    
    
  end

end