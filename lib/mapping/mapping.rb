module Waves

  module Mapping
    
    METHODS = %w( get put post delete ).map( &:intern )
    
    def method_missing(name,*args,&block)
      mappings[ name ].push( map( *args, &block ) )
    end
    
    def with( options, &block )
      @options = options; yield if block_given? ; @options = nil
    end

    def path( name, options = {}, &block )
      map( options.merge!( :name => name, :target = :path ), &block )
    end
    
    def url( name, options = {}, &block )
      map( options.merge!( :name => name, :target = :url ), &block )
    end
    
    def map( *args, &block )
      options = ( @options || {} ).merge( normalize( *args ).merge( :lambda => block ) )
      METHODS.each do |method|
        if options[ method ]
          options.merge!( :pattern => options[ method ], :method => method )
          options[ :target ] ||= :path
        end
      end
      Action.new( options )
    end
    
    functor( :normalize, Symbol, Hash ) { | name, options | options.merge!( :name => name ) }
    functor( :normalize, String, Hash ) { | pattern, options | options.merge!( :pattern => pattern ) }
    functor( :normalize, Regexp, Hash ) { | regexp, options | options.merge!( :pattern => regexp ) }
    functor( :normalize, Exception ) { | exception | { :exception => exception } } 
    functor( :normalize, Hash ) { | options | options }    
    
  end
  

end