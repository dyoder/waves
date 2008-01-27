require 'logger'
module Waves
	
	module Logger

		# Initializes the logger based on the config, and then adds Waves#log.

		def self.start
			config = Waves::Server.config
			output = ( config.log[:output] || $stderr )
			level = ::Logger.const_get( config.log[:level].to_s.upcase || 'INFO' )
			@log = if config.log(:rotation)
  			::Logger.new( output, config.log[:rotation].intern ); 
  		else
  			::Logger.new( output ); 
  		end
			@log.level = level
		end
		
		# delegate everything to the logger
		def self.method_missing(name,*args,&block)
		  @log.send name,*args, &block
		end
		
	end

end

