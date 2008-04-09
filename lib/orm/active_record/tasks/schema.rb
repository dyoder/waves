require File.dirname(__FILE__) / ".." / ".." / :migration_helper
include Waves::Orm
namespace :schema do

	desc "Create a new ActiveRecord Migration using ENV['name']."
  task :migration do |task|
	
		source          = Migration.template(:active_record, ENV['template'])
		destination     = Migration.destination(ENV['name'])
		migration_name  = Migration.migration_name(ENV['name'])
		
		context = {:class_name => migration_name.camel_case}
		
		Migration.write_erb(context, source, destination)

	end
	
	desc 'Performs migration from version, to version.'
	task :migrate => :connect do |task|
	  version = ENV['VERSION'] ? ENV['VERSION'].to_i : nil
	  ActiveRecord::Migrator.migrate(Migration.directory, version)
	end
	
	task :connect do
    Application.database
    ActiveRecord::Base.logger = Logger.new($stdout)
	end
	
end

