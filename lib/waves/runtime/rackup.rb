module Waves

  # Runtime to use with Rackup specifically.
  #
  # The actual Rack application is built using `config.application`
  # (see runtime/configuration.rb), not in the .ru file. Rackup
  # expects to be used in the context of an already-running server.
  # See the documentation for your webserver and Rack for details.
  #
  # Your config.ru file should minimally look something like this:
  #
  #   WAVES = ENV["WAVES"] || File.join(File.dirname(__FILE__), "waves", "lib")
  #
  #   $LOAD_PATH.unshift WAVES
  #
  #   require "waves"
  #   require "waves/runtime/rackup"
  #
  #   run Waves::Rackup.load(:startup => "run_giraffe_run.rb")
  #
  class Rackup < Runtime

    # Create a runtime, run the startup file and return an application.
    #
    def self.load(options = {})
      new options
      Kernel.load(options[:startup] || "startup.rb")

      Waves.config.application
    end

  end

end

