%w( rubygems test/spec mocha ).each { |f| require f }

# protext TextMate from itself
$:.reject! { |e| e.include? 'TextMate' }
require 'redgreen' if ENV['TM_FILENAME'].nil?

# cd to the root of the app directory
Dir.chdir(File.join(File.dirname(__FILE__), "test_app"))

# Pull in the framework
require File.join("lib", "framework")
