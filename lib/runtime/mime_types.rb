module Waves
  
  # Waves::MimeTypes defines an interface for adding MIME types used in mapping requests
  # to content types. Mongrel's MIME_TYPES hash is used as the baseline MIME map.
  
  module MimeTypes
    
    def self.[]( path )
      mapping[ File.extname( path ) ]
    end
    
    # TODO: This does not seem to be working.
    def self.<<( mapping )
      mapping.merge!( mapping )
    end
    
    def self.mapping
      @mapping ||= Mongrel::DirHandler::MIME_TYPES
    end
    
  end
end