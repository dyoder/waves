namespace :generate do
  desc 'Generate a new model'
  task :model do |task|
    template = File.read :models / 'default.rb'
    File.write( :models / ENV['name'] + '.rb',
      template.gsub('class Default < Sequel::Model',
      "class #{ENV['name'].camel_case} < Sequel::Model(:#{ENV['name'].plural})") )
  end
end
