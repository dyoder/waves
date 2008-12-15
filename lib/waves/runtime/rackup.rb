module Waves

  class Rackup < Runtime

    def self.load(options = {})
      new options
      Kernel.load(options[:startup] || "startup.rb")

      Waves.config.application
    end

  end

end

