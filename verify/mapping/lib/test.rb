require 'sequel'
module Test

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
			  autocreate true, eval("Test::Models::Default") do
			    set_dataset Test.database[ basename.snake_case.plural.intern ]
			  end
			# everything else just use the exemplar
			else
			  autocreate true, eval("Test::#{name}::Default")
			end

		end

	end
		
	# accessor methods for modules and other key application objects ...
	class << self
		def config ; Waves::Server.config rescue nil || Waves::Console.config ; end
		def database ; @database ||= Sequel.open( config.database ) ; end
		def configurations ; Test::Configurations ; end
		def controllers ; Test::Controllers ; end
		def models ; Test::Models ; end
		def helpers ; Test::Helpers ; end
		def views ; Test::Views ; end
	end
	
end