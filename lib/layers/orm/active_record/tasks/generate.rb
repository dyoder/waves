namespace :generate do
  
    desc 'Generate an ActiveRecord model, with name=<name>'
    task :model do |task|
      name = ENV['name']
      model_name = name.camel_case
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