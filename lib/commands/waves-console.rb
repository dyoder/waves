require 'waves'
require 'choice'

Choice.options do
  header 'Run waves in console mode.'
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
end
    
Waves::Console.load( Choice.choices )
require 'irb'
require 'irb/completion'
ARGV.clear # make sure arguments to waves-console don't propagate to irb
IRB.start