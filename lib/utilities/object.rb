class Objec
  # This is an extremely powerful little function that will be built-in to Ruby 1.9.
  # This version is from Mauricio Fernandez via ruby-talk. Works like instance_eval
  # except that you can pass parameters to the block. This means you can define a block
  # intended for use with instance_eval, pass it to another method, which can then
  # invoke with parameters. This is used quite a bit by the Waves::Mapping code.
  def instance_exec(*args, &block)
    mname = "__instance_exec_#{Thread.current.object_id.abs}"
    class << self; self end.class_eval{ define_method(mname, &block) }
    begin
      ret = send(mname, *args)
    ensure
      class << self; self end.class_eval{ undef_method(mname) } rescue nil
    end
    re
  end
end
