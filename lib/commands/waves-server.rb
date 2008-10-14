require 'choice'

Choice.options do
  header 'Run a waves application server.'
  header ''
  option :port  do
    short '-p'
    long '--port=PORT'
    desc 'Port to listen on.'
    desc 'Defaults to value given in configuration.'
    cast Integer
  end
  separator ''
  option :host do
    short '-h'
    long '--host=HOST'
    desc 'Host or IP address of the host to bind.'
    desc 'Defaults to value given in configuration.'
  end
  separator ''
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
  option :daemon do
    short '-d'
    long '--daemon'
    desc 'Run as a daemon.'
  end
  separator ''
  option :turbo do
    short '-t'
    long '--turbo'
    desc 'For thread-safe applications, run without dispatch level mutex.'
  end
  separator ''
  option :debugger do
    short '-u'
    long '--debugger'
    desc 'Enable ruby-debug.'
  end
  separator ''
  option :startup do
    short '-s'
    long '--startup=PATH'
    desc 'Startup file to load.'
    desc 'Defaults to "startup.rb"'
  end
  separator ''
end
Waves::Manager.run( Choice.choices )
