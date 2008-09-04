namespace :generate do
  
  # We're declaring these tasks first so we can add descriptions.
  # The real work is done in the rule, below.
  desc 'Generate new controller, with name=<name>'
  task :controller
  
  desc 'Generate new view, with name=<name>'
  task :view
  
  desc 'Generate new resource, with name=<name>'
  task :resource
  
  # Rake rules are awesome.  In the main block, t.name is the task name that matched
  # the regex.  t.source is the string returned by the lambda argument to rule.
  rule( /controller|view|resource/ => lambda { |task| basetask(task).camel_case << "s" } ) do |t|
    content = class_template( app_name, t.source, constant_name )
    name = basetask(t.name) << "s"
    File.write( filename( name ), content )
  end
  
  desc 'Generate new helper, with name=<name>'
  task :helper do |task|
    content = module_template( app_name, "Helpers", constant_name) do
      "include Waves::Helpers::Default"
    end
    File.write( filename( "helpers" ), content )
  end
  
end

desc "Generate resource, controller, view, and helper with name=<name>"
task :generate => %w{ generate:resource generate:controller generate:view generate:helper }

# Helper methods

def app_name
  ( ENV['app'] || Dir.pwd.split('/').last ).camel_case
end

def constant_name
  str = ENV['name'].camel_case
  raise "Cannot generate Default yet" if str == 'Default'
  str
end

def filename( kind )
  path = File.expand_path "#{kind}/#{ENV['name'].snake_case}.rb"
  if File.exist?(path)
    $stderr.puts "  Problem encountered:\n  #{path} already exists"
    exit
  end
  path
end

# Rake only pretends to namespace tasks, so to get what we think of as
# the task name, you must split and grab.
def basetask(str)
  str.split(":").last
end

def class_template(app_name, place, class_name)
  str = <<TEXT
module #{app_name}
  module #{place}
    class #{class_name} < Default

    end
  end
end
TEXT
end

# This method expects its block to return something usable as a string.
def module_template(app_name, place, module_name, &block)
  str = <<TEXT
module #{app_name}
  module #{place}
    module #{module_name}
      #{block.call if block}
    end
  end
end
TEXT
end
