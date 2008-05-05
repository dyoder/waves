module Kernel
  #
  # From Rails. This comes in handy when you want to return a value that you need to modify. 
  # So instead of the awkward:
  #
  #   foo = Foo.new
  #   foo.bar = 'bar'
  #   foo
  #
  # You can just say
  # 
  #   returning Foo.new { |foo| foo.bar = 'bar' }
  #
  def returning( object, &block )
    yield object; object
  end
  
  #
  # Inspired by a question on comp.lang.ruby. Sort of like returning, except
  # you don't need to pass in the returnee as an argument. The drawback is that,
  # since this relies on instance_eval, you can't access in methods in the local
  # scope. You can work around this by assigning values to variables, but in that
  # case, you might be better off using returning.
  #
  # Our above example would look like this:
  #
  #   with( Foo.new ) { bar = 'bar' }
  #
  def with( object, &block )
    object.instance_eval(&block); object
  end
  

end