#!/usr/bin/env ruby
#
# Warning:  This file is clobbered when you update your
# application with the waves script.  Accordingly, you may
# wish to keep your tasks in .rb or .rake files in lib/tasks

require 'rubygems'

WAVES = "#{File.dirname(__FILE__)}/.." unless defined? WAVES

waves = [
  WAVES, ENV['WAVES'], './waves'
].compact.map { |dir| File.join(dir, 'lib') }.find { |d|
  File.exist? File.join( d, 'waves.rb' )
}
if waves
  $: << waves
  waves = File.join( waves, 'waves' )
else
  waves = 'waves'
end

require waves
require 'runtime/console'

begin
  Waves::Console.load(:mode => ENV['mode'])

  # load tasks from waves framework
  %w( generate gem ).each { |task| require "tasks/#{task}.rb" }

  # load tasks from this app's lib/tasks
  Dir["lib/tasks/*.{rb,rake}"].each { |task| require task }
  
rescue LoadError => e
  if e.message == 'no such file to load -- waves'
    puts "Can't find Waves source.  Install gem, freeze Waves, or define WAVES at the top of the Rakefile"
    puts
  else
    raise e
  end
end

namespace :waves do
  
  desc "freeze src=<wherever> to ./waves"
  task :freeze do

    target = "#{Dir.pwd}/waves"
    src = ENV['src']
    raise "Please specify the location of waves using src=wherever" unless src
    raise "No directory found at '#{src}'" unless File.directory?(src) 
      
    items = FileList["#{src}/*"]
    puts "Freezing from: #{src}"
    items.each do |item|
      puts "copying #{item}"
      cp_r item, target
    end
    
  end
  
  desc "unfreeze (i.e. delete) the waves source at ./waves"
  task :unfreeze do
    frozen = "#{Dir.pwd}/waves"
    rm_r frozen if File.exist?(frozen)
  end
  
  # Convenience task to allow you to freeze the current Waves
  # source without knowing where it is.  This task only gets
  # defined when the Rakefile successfully loaded Waves and if
  # there's nothing in the way at ./waves
  if defined?(WAVES) && !File.exist?("#{Dir.pwd}/waves")
    namespace :freeze do
      desc "freeze current Waves source to ./waves"
      task :current do
        target = "#{Dir.pwd}/waves"
        current = File.expand_path( WAVES )
        items = FileList["#{current}/*"]
        puts "Freezing from: #{current}"
        items.each do |item|
          puts "copying #{item}"
          cp_r item, target
        end

      end
    end
  end
  
end