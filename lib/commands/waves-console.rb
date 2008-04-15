require 'waves'
require 'choice'

Choice.options do
  header 'Run a waves application server.'
  header ''
  option :mode do
    short '-c'
    long '--config=CONFIG'
    desc 'Configuration to use.'
    desc 'Defaults to development.'
    cast Symbol
  end
  separator ''
  option :directory do
    short '-D'
    long '--dir=DIR'
    desc 'Directory containing the application.'
    desc 'Defaults to the current directory.'
  end
  separator ''
  option :startup do
    short '-s'
    long '--startup'
    desc 'Startup file to load.'
    desc 'Defaults to "lib/startup.rb"'
  end
  separator ''  
end
require 'irb'; IRB.start