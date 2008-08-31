class Functor
  
  def before( &block ) ; @before ||= [] ; @before << block ; end
  def after( &block ) ; @after ||= [] ;  @after << block ; end
  def wrap( &block ) ; before( &block ) ; after( &block ) ; end
  
  def apply( object, *args, &block )
    functor = match( args, &block )
    @before.each { |x| object.instance_eval( &x ) }
    object.instance_exec( *args, &functor )
    @after.each { |x| object.instance_eval( &x ) }
  end
  
  def call( *args, &block )
    functor = match( args, &block )
    @before.each { |x| x.call }
    functor.call( *args )
    @after.each { |x| x.call }
  end
  
end
  