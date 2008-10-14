require 'logger'
module Waves

  # Waves::Logger is based on Ruby's built-in Logger. It uses the same filtering approach
  # (debug, info, warn, error, fatal), although the interface is slightly different.
  # You won't typically instantiate this class directly; instead, you will specify the
  # logging configuration you want in your configuration files. See Waves::Configurations
  # for more information on this.
  #
  # To use the logger for output, you can usually just call +log+, since the Waves::ResponseHelper
  # mixin defines it (meaning it is available in the mapping file, controllers, views, and
  # templates). Or, you can access Waves::Logger directly. Either way, the logger provides five
  # methods for output corresponding to the log levels.
  #
  # *Examples*
  #   # log the value of foo
  #   log.info "Value of foo: #{foo}"
  #
  #   # fatal error!
  #   Waves::Logger.fatal "She can't hold up any longer, cap'n!"
  #
  module Logger

    # Returns the object being used for output by the logger.
    def self.output
      @output ||= ( config[:output] or $stderr )
    end
    
    # Returns the active configuration for the logger.
    def self.config ; @config ||= Waves.config.log ; end
    
    # Returns the logging level used to filter logging events.
    def self.level ; @level ||= ::Logger.const_get( config[:level].to_s.upcase || 'INFO' ) ; end
    
    # Starts the logger, using the active configuration to initialize it.
    def self.start
      @log = config[:rotation] ?
        ::Logger.new( output, config[:rotation].to_sym ) :
        ::Logger.new( output )
      @log.level = level
      @log.datetime_format = "%Y-%m-%d %H:%M:%S "
      self
    end
    
    # Forwards logging methods to the logger.
    def self.method_missing(name,*args,&block)
      @log.send name,*args, &block if @log
    end

  end

end

