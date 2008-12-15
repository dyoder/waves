module Waves
  module Ext
    module Object
      # This is an extremely powerful little function that will be built-in to Ruby 1.9.
      # This version is from Mauricio Fernandez via ruby-talk. Works like instance_eval
      # except that you can pass parameters to the block.
      def instance_exec(*args, &block)
        mname = "__instance_exec_#{Thread.current.object_id.abs}"
        class << self; self end.class_eval{ define_method(mname, &block) }
        begin
          ret = send(mname, *args)
        ensure
          class << self; self end.class_eval{ undef_method(mname) } rescue nil
        end
        ret
      end
      
      def cache_method_missing(name, method_body, *args, &block)
        self.class.module_eval <<-METHOD
          def #{name}(*args, &block)
            #{method_body}
          end
        METHOD
        self.send(name, *args, &block)
      end
      
    end
  end
end

class Object # :nodoc:
  include Waves::Ext::Object
end