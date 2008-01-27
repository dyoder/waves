class Integer
	def seconds ; self ; end
	def minutes ; self * 60 ; end
	def hours ; self * 60.minutes ; end
	def days ; self * 24.hours ; end
	def weeks ; self * 7.days ; end
	# months and years are not precise
end