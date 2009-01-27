WAVES = ENV["WAVES"] || File.join(File.dirname(__FILE__), "waves", "lib")

$LOAD_PATH.unshift WAVES

require "waves"
require "waves/runtime/rackup"

run Waves::Rackup.load(:startup => "basic_startup.rb")

