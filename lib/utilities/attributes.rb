module Attributes
	
	def initialize(hash={})
	  # copy the hash, converting all keys to strings
		@attrs = hash.inject({}) { |h,p| k,v = p; h[k.to_s] = v; h  }
	end
	
	def method_missing(name,*args)
	  name = name.to_s
		if name =~/=$/ and args.length == 1
			set(name[0..-2], args[0] )
		else
			get(name)
		end
	end
	
	def [](name)
		get(name)
	end
	
	def []=(name,val)
		set(name,val)
	end
	
	def set(name, val)
		@attrs[name.to_s] = val
	end
	
	def get(name)
		rval = ( @attrs[name.to_s] )
		if Hash === rval
			Attributes.new(rval)
		else
			rval
		end
	end
	
	def to_h
		@attrs
	end
	
  alias_method :to_hash, :to_h
  
end
	
	