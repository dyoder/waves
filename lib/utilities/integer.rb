# Added methods to Integer for commonly used "numeric phrases" like 6.days or 30.megabytes.
class Integer
	def seconds ; self ; end
	def minutes ; self * 60 ; end
	def hours ; self * 60.minutes ; end
	def days ; self * 24.hours ; end
	def weeks ; self * 7.days ; end
	def bytes ; self ; end
	def kilobytes ; self * 1024 ; end
	def megabytes ; self * 1024.kilobytes ; end
	def gigabytes ; self * 1024.megabytes ; end
	def terabytes ; self * 1024.gigabytes ; end
	def petabytes ; self * 1024.gigabytes ; end
end