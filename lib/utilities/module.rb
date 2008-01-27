class Module

	def basename
		self.name.split('::').last || ''
	end

end
