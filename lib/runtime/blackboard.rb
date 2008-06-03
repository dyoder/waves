module Waves

  # Encapsulates the blackboard associated with a given request. The scope of the blackboard is
  # the same as the request object it gets attached to.
  #
  # The Waves blackboard is a very simple shared storaged usable during the request processing.
  # It is available within:
  #    - mappings
  #    - controllers
  #    - helpers
  #
  # Adding a value:
  #   blackboard.value1 = 1
  #   blackboard[:value2] = 2
  #
  # Retrieving values
  #   blackboard.value1
  #   blackboard[:value2]
  #
  # see also blackboard_verify.rb  
  
  class Blackboard

    # Create a new blackboard object using the given request.
    def initialize( request )
      @request = request
      @data = {}
    end

    # Access a given data element of the blackboard using the given key.
    def [](key)
      @data[key]
    end

    # Set the given data element of the blackboard using the given key and value.
    def []=(key,val)
      @data[key] = val
    end
    
    def each(&block)
      @data.each(&block)
    end

    # also allow things like
    # blackboard.test1 instead of blackboard[:test1]
    # blackboard.test1 = 2 instead of blackboard[:test1] = 2
    def method_missing(name,*args)
      if (name.to_s =~ /=$/)
        self[name.to_s.gsub('=', '')] = args[0]
      else
        self[name.to_s]
      end
    end

  end
  
end