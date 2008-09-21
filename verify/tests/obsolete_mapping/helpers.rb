require "#{File.dirname(__FILE__)}/../../helpers"

# define basic app for use in testing
# before methods may add to it using helper methods
clear_all_apps
module MappingApp ; include Waves::Foundations::Default ; end
Waves << MappingApp
RMA = MappingApp
Waves::Console.load( :mode => :development )