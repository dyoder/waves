%w( rubygems bacon facon ).each { |f| require f }
Bacon.extend Bacon::TestUnitOutput
Bacon.summary_on_exit
