module Kernel
	
	# inspired by similar function in rails ...
	def returning( object, &block )
		yield object; object
	end

end