class Functor
  
  module Method
    def self.included( k )
      def k.functor( name, *args, &block )
        functors = module_eval { @__functors ||= {} }
        unless functors[ name ]
          functors[ name ] = Functor.new
          eval <<-CODE
            def #{name}( *args, &block ) 
              begin
                functors = self.class.module_eval { @__functors }
                functors[ :#{name} ].bind( self ).call( *args, &block ) 
              rescue ArgumentError => e
                begin
                  super
                rescue NoMethodError => f
                  raise e
                end
              end
            end
          CODE
        end
       functors[ name ].given( *args, &block )
      end
    end
  end
  
  def initialize( &block ) ; @patterns = []; instance_eval(&block) if block_given? ; end
  
  def given( *pattern, &block ) ; @patterns.push [ pattern, block ] ; self ; end
  
  def bind( object ) ; @object = object ; self ; end
  
  def call( *args, &block )
    args.push( block ) if block_given?
    pattern, action = @patterns.find { |pattern, action| match?( args, pattern ) }
    raise ArgumentError.new( "argument mismatch for argument(s): #{args.inspect}." ) unless action
    @object ? @object.instance_exec( *args, &action ) : action.call( *args )
  end
  
  def to_proc
    lambda { |*args| self.call(*args) }
  end
  
  private
  
  def match?( args, pattern )
    pattern.zip(args).all? { |x,y| x === y or x == y } if pattern.length == args.length
  end
  
end