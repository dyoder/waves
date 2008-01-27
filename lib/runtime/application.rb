module Waves

	class << self
		
		attr_reader :application
		
		# give us the root namespace for the application
		def << ( app )
			@application = app if Module === app
		end
		
	end
	
	class Application
		
		def initialize( mode = :development )
			@mode = mode
		end
		
		def debug? ; @mode == :development ; end

		# now we can get the configuration, based on the mode
		# we must specify global scope to avoid picking up Waves::Configurations::*
		# and / or Waves::Application::* ... because the configuration may be
		# loaded via autoload ....
		def config
			Waves.application.configurations[ @mode ]
		end

		# and, similarly, the url mapping ...
		def mapping
			Waves.application.configurations[ :mapping ]
		end

		# the config then tells us whether to unload any namespaces
		# after each request ...
		def reset
			config.reloadable.each { |mod| mod.reload }
		end

	end

end