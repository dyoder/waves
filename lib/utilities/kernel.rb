module Kernel
  unless respond_to?(:debugger)
    # Starts a debugging session if ruby-debug has been loaded (call waves-server --debugger to do load it).
    def debugger
      puts "debugger called"
      Waves::Logger.info "\n***** Debugger requested, but was not available: Start server with --debugger to enable *****\n"
    end
  end

  unless respond_to?(:engine)
    # 'engine' exists to provide a quick and easy (and MRI-compatible!) interface to the RUBY_ENGINE constant
    def engine
      defined?(RUBY_ENGINE) ? RUBY_ENGINE : 'mri'
    end
  end
end
