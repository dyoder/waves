require File.join(File.dirname(__FILE__) , "..", "helpers")

# define basic app for use in testing
# before methods may add to it using helper methods
module ResourceMappingApp ; include Waves::Foundations::Default ; end
Waves << ResourceMappingApp
RMA = ResourceMappingApp
Waves::Console.load( :mode => :development )