namespace :generate do
  
    desc 'Generate a Sequel model, with name=<name>'
    task :model do |task|

      model_name = ENV['name'].camel_case
      app_name = ( ENV['app'] || Dir.pwd.split('/').last ).camel_case

      raise "Cannot generate Default yet" if model_name == 'Default'

      filename = File.expand_path "models/#{name}.rb"
      if File.exist?(filename)
        $stderr.puts "#{filename} already exists" 
        exit
      end

      model = <<TEXT
module #{app_name}
  module Models
    class #{model_name} < Default

    end
  end
end
TEXT

      File.write( filename, model )
    end
  
end