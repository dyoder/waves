module Attributes
  
	def initialize(hash = {} )
	  attributes = hash
	end
	
	def attributes=( hash )
	  # copy the hash, converting all keys to strings
		@attrs = hash.inject({}) { |h,p| k,v = p; h[k.to_s] = v; h  }
	end
	
	def attributes
	  @attrs ||= {}
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
		attributes[name.to_s] = val
	end
	
	def get(name)
		rval = attributes[name.to_s]
		rval.is_a?( Hash ) ? Attributes.new( rval ) : rval
	end
	
	def to_h
		@attrs
	end
	
  alias_method :to_hash, :to_h
  
  class Object
    include Attributes
  end
  
end
	
	