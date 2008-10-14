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
  option :startup do
    short '-s'
    long '--startup'
    desc 'Startup file to load.'
    desc 'Defaults to "startup.rb"'
  end
  separator ''
end

begin
  console = Waves::Console.load( Choice.choices )
  Object.send(:define_method, :waves) { console }
  require 'irb'
  require 'irb/completion'
  ARGV.clear
  Waves.log.info "Runtime console starting ..."
  IRB.start
rescue LoadError => e
  puts e.message
end