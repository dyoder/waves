namespace :generate do
  
  desc 'Generate a new model'
  task :model do |task|
    name = ENV['name']
    # template = File.read :models / 'default.rb'
    # File.write( :models / ENV['name'] + '.rb',
    #   template.gsub('class Default < Sequel::Model',
    #   "class #{ENV['name'].camel_case} < Sequel::Model(:#{ENV['name'].plural})") )
  end
  
  desc 'Generate a new controller'
  task :controller do |task|
    # template = File.read :controllers / 'default.rb'
    # File.write( :controllers / ENV['name'] + '.rb',
    #   template.gsub('class Default',"class #{ENV['name'].camel_case}") )
  end
  
  task :view do |task|
    
  end

  task :helper do |task|
    
  end
  
  desc 'generates a model, controller, view, helper, and template dir'
  task :resource do |task|
    
  end
  
end
