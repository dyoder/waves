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
end
    
Waves::Console.load( Choice.choices )
require 'irb'; IRB.start