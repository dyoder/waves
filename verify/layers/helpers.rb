%w( rubygems bacon facon extensions/all).each { |f| require f }

Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit

# Prepend the framework lib to the loadpath
$:.unshift( File.join(File.dirname(__FILE__), "..", "..", "lib") )
require 'waves'

def rm_if_exist(name)
  FileUtils.rm name if File.exist? name
end

# add block to Bacon's before and after blocks
def wrap(&block)
  @before << block
  @after << block
end
