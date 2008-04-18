require 'sequel'
module Blog

	extend Autocreate; extend Autoload; extend Reloadable
	autoload true; directories :lib

	[ :Configurations, :Models, :Views, :Controllers, :Helpers ].each do | name |
		autocreate( name, Module.new ) do

      # dynamically access module constants
			def self.[]( cname )
			  eval("#{name}::#{cname.to_s.camel_case}")
			end

		  # first try to load and only create if that fails
		  # which means install autoload *after* autocreate
		  extend Autocreate; extend Autoload
		  
		  # autoload any files in appropriately named directories
		  # exampe: models/blog.rb for Blog
			autoload true; directories name.to_s.snake_case
			
			# autocreate declarations ...
			case name
		  # don't autocreate configs
		  when :Configurations then nil
		  # set the dataset for Models
		  when :Models
			  autocreate true, eval("Blog::Models::Default") do
			    set_dataset Blog.database[ basename.snake_case.plural.intern ]
			  end
			# everything else just use the exemplar
			else
			  autocreate true, eval("Blog::#{name}::Default")
			end

		end

	end
		
	# accessor methods for modules and other key application objects ...
	class << self
		def config ; Waves::Server.config rescue nil || Waves::Console.config ; end
		def database ; @database ||= Sequel.open( config.database ) ; end
		def configurations ; Blog::Configurations ; end
		def controllers ; Blog::Controllers ; end
		def models ; Blog::Models ; end
		def helpers ; Blog::Helpers ; end
		def views ; Blog::Views ; end
	end
	
end