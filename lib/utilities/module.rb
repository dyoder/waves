class Module

  # This comes in handy when you are trying to do meta-programming with modules / classes
  # that may be nested within other modules / classes. I think I've seen it defined in 
  # facets, but I'm not relying on facets just for this one method.
	def basename
		self.name.split('::').last || ''
	end

end
