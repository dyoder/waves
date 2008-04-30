#!/usr/bin/env ruby
# 
# Warning:  This file is clobbered when you update your
# application with the waves script.  Accordingly, you may
# wish to keep your tasks in .rb or .rake files in lib/tasks
require 'startup'
Waves::Console.load(:mode => ENV['mode'])

# load tasks from waves framework
%w( schema cluster generate gem ).each { |task| require "tasks/#{task}.rb" }

# load tasks from this app's lib/tasks
Dir["lib/tasks/*.{rb,rake}"].each { |task| require task }

