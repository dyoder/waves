require 'startup'
require 'lib/application.rb'


Waves::Console.load

instance_eval  &Waves.config.rack_builder

