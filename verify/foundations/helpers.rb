%w( rubygems bacon extensions/all).each { |f| require f }

Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

# Prepend the framework lib to the loadpath
$:.unshift( File.join(File.dirname(__FILE__), "..", "..", "lib") )
require 'waves'

def defined
  lambda { |obj| defined?(obj) }
end
