require File.join(File.dirname(__FILE__) , "..", "helpers")

# define basic app for use in testing
# before methods may add to it using helper methods
module MappingApp ; include Waves::Foundations::Simple ; end
Waves << MappingApp
Waves::Console.load( :mode => :development )