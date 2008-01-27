module Waves
	module MimeTypes
	  
		def self.[]( path )
		  mapping[ File.extname( path ) ]
		end
		
		# TODO: why isn't this working?
		# def self.<<( mapping )
		#  mapping.merge!( mapping )
		# end
		
		def self.mapping
		  @mapping ||= Mongrel::DirHandler::MIME_TYPES
		end
		
	end
end