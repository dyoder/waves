
module Waves

  module Cache

    # Looks barebones in here, huh?
    # That's because the Waves::Cache API is implemented in a separate file.
    require 'cache/cache-ipi' # iPi stands for Implemented Programming Interface, aka inherently interchangeable.
    
    
    # Waves::Cache module also has some...
    # Exception classes
    class KeyMissing < StandardError; end
    class KeyExpired < StandardError; end

    # ...and a class method to initiate the iPi seamlessly. (see layers/cache/file* for an example of a layered iPi)
    def self.new
      Waves::Cache::IPI.new
    end

  end
end