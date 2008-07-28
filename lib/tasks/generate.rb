namespace :generate do

  desc 'Generate a new controller, with name=<name>'
  task :controller do |task|
    name = ENV['name']
    controller_name = name.camel_case
    app_name = ( ENV['app'] || Dir.pwd.split('/').last ).camel_case
    
    raise "Cannot generate Default yet" if controller_name == 'Default'
    
    filename = File.expand_path "controllers/#{name}.rb"
    if File.exist?(filename)
      $stderr.puts "#{filename} already exists" 
      exit
    end

    controller = <<TEXT
module #{app_name}
  module Controllers
    class #{controller_name} < Default

    end
  end
end
TEXT

    File.write( filename, controller )
  end
  
  desc 'Generate new view, with name=<name>'
  task :view do |task|
    name = ENV['name']
    view_name = name.camel_case
    app_name = ( ENV['app'] || Dir.pwd.split('/').last ).camel_case
    
    raise "Cannot generate Default yet" if view_name == 'Default'
    
    filename = File.expand_path "views/#{name}.rb"
    if File.exist?(filename)
      $stderr.puts "#{filename} already exists" 
      exit
    end

    view = <<TEXT
module #{app_name}
  module Views
    class #{view_name} < Default

    end
  end
end
TEXT

    File.write( filename, view )
  end
 
  desc 'Generate a new helper, with name=<name>'
  task :helper do |task|
    name = ENV['name']
    helper_name = name.camel_case
    app_name = ( ENV['app'] || Dir.pwd.split('/').last ).camel_case
    
    raise "Cannot generate Default yet" if helper_name == 'Default'
    
    filename = File.expand_path "helpers/#{name}.rb"
    if File.exist?(filename)
      $stderr.puts "#{filename} already exists" 
      exit
    end
    
    helper = <<TEXT
module #{app_name}
  module Helpers
    module #{helper_name}
      include Waves::Helpers::Default
      
    end
  end
end
TEXT

    File.write( filename, helper )
  end
  
  
end