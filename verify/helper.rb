%w( rubygems test/spec mocha ).each { |f| require f }

# protext TextMate from itself
$:.reject! { |e| e.include? 'TextMate' }
require 'redgreen' if ENV['TM_FILENAME'].nil?

# Pull in the framework
require File.join(File.dirname(__FILE__), "test_app", "lib", "framework")

# Make sure we're in the app root directory
Dir.chdir(File.dirname(__FILE__) / "test_app")

# Boom.
Waves::Console.load(:mode => 'development')