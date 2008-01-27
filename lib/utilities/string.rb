class String
	
	# I unfortunately don't recall where i first saw this ... see
	# Symbol extension as well, allowing for :files / 'afilename.txt'
	
	def / ( string )
		File.join(self,string.to_s)
	end

	# inspired by the inflector code in rails ...
	
	def singular
		gsub(/ies$/,'y').gsub(/es$/,'').gsub(/s$/,'')
	end

	def plural
		gsub(/(s|sh|ch)$/,'\1es').gsub(/(i|y)$/,'ies').gsub(/([^s])$/,'\1s')
	end

	def camel_case
		gsub(/(_)(\w)/) { $2.upcase }.gsub(/^([a-z])/) { $1.upcase }
	end		
	
	def snake_case
    gsub(/([a-z\d])([A-Z])/){ "#{$1}_#{$2}"}.tr("-", "_").downcase
	end
	
	def title_case
		gsub(/(^|\s)\s*([a-z])/) { $1 + $2.upcase }
	end
	
	def text
		gsub(/[\_\-\.\:]/,' ')
	end
	
end